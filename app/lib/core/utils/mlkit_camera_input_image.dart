import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

/// Converte [CameraImage] em [InputImage] para ML Kit (NV21 + BGRA8888, um plano).
///
/// O [CameraController] deve usar:
/// - Android: [ImageFormatGroup.nv21]
/// - iOS: [ImageFormatGroup.bgra8888]
///
/// Baseado no exemplo oficial:
/// https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/camera_view.dart
InputImage? inputImageFromCameraImage({
  required CameraImage image,
  required CameraController controller,
}) {
  if (kIsWeb) {
    return null;
  }

  final camera = controller.description;
  final sensorOrientation = camera.sensorOrientation;

  final orientations = <DeviceOrientation, int>{
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImageRotation? rotation;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    var rotationCompensation =
        orientations[controller.value.deviceOrientation];
    if (rotationCompensation == null) {
      return null;
    }
    if (camera.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  } else {
    return null;
  }

  if (rotation == null) {
    return null;
  }

  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  if (format == null ||
      (defaultTargetPlatform == TargetPlatform.android &&
          format != InputImageFormat.nv21) ||
      (defaultTargetPlatform == TargetPlatform.iOS &&
          format != InputImageFormat.bgra8888)) {
    return null;
  }

  if (image.planes.length != 1) {
    return null;
  }
  final plane = image.planes.first;

  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: plane.bytesPerRow,
    ),
  );
}
