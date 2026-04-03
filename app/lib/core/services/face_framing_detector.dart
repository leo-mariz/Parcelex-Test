import 'package:app/core/enums/face_framing/face_framing_phase.dart';
import 'package:app/core/models/face_framing_thresholds.dart';
import 'package:app/core/utils/mlkit_camera_input_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../models/face_framing_snapshot.dart';

/// Detecta rosto em um frame da câmera e devolve fase de enquadramento para a UI customizada.
abstract interface class FaceFramingDetector {
  Future<FaceFramingSnapshot> analyzeCameraFrame({
    required CameraImage image,
    required CameraController controller,
  });

  /// Libera o detector nativo (ex.: ML Kit). Chame ao descartar o cubit dono da instância.
  Future<void> dispose();
}


/// Implementação com [Google ML Kit Face Detection] on-device.
///
/// Requer [CameraController] com [ImageFormatGroup.nv21] (Android) ou
/// [ImageFormatGroup.bgra8888] (iOS), conforme doc do ML Kit.
class MlKitFaceFramingDetector implements FaceFramingDetector {
  MlKitFaceFramingDetector({
    FaceFramingThresholds? thresholds,
    FaceDetectorOptions? detectorOptions,
  })  : _thresholds = thresholds ?? const FaceFramingThresholds(),
        _faceDetector = FaceDetector(
          options: detectorOptions ??
              FaceDetectorOptions(
                enableClassification: false,
                enableLandmarks: false,
                enableContours: false,
                enableTracking: true,
                minFaceSize: 0.12,
                performanceMode: FaceDetectorMode.fast,
              ),
        );

  final FaceFramingThresholds _thresholds;
  final FaceDetector _faceDetector;
  bool _disposed = false;

  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<FaceFramingSnapshot> analyzeCameraFrame({
    required CameraImage image,
    required CameraController controller,
  }) async {
    if (_disposed || !_supported) {
      return FaceFramingSnapshot.initial;
    }

    final input = inputImageFromCameraImage(image: image, controller: controller);
    if (input == null) {
      return FaceFramingSnapshot.initial;
    }

    final faces = await _faceDetector.processImage(input);
    if (faces.isEmpty) {
      return const FaceFramingSnapshot(
        phase: FaceFramingPhase.noFace,
        faceWidthFraction: null,
        faceCount: 0,
      );
    }

    Face largest = faces.first;
    var maxArea = largest.boundingBox.width * largest.boundingBox.height;
    for (var i = 1; i < faces.length; i++) {
      final f = faces[i];
      final a = f.boundingBox.width * f.boundingBox.height;
      if (a > maxArea) {
        maxArea = a;
        largest = f;
      }
    }

    final imageWidth = image.width.toDouble();
    if (imageWidth <= 0) {
      return FaceFramingSnapshot.initial;
    }

    final widthFraction = largest.boundingBox.width / imageWidth;
    final phase = _thresholds.phaseForWidthFraction(
      widthFraction,
      hasFace: true,
    );

    return FaceFramingSnapshot(
      phase: phase,
      faceWidthFraction: widthFraction,
      faceCount: faces.length,
    );
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await _faceDetector.close();
  }
}
