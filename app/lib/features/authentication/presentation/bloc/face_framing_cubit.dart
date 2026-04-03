import 'package:app/core/models/face_framing_snapshot.dart';
import 'package:app/core/services/face_framing_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Orquestra análise de frames da câmera e emite [FaceFramingSnapshot] para a UI.
///
/// Chame [onCameraImage] a partir do [CameraController.startImageStream] com throttle
/// na página (ex.: 1 frame a cada 150–200 ms) para não sobrecarregar a CPU.
class FaceFramingCubit extends Cubit<FaceFramingSnapshot> {
  FaceFramingCubit(this._detector) : super(FaceFramingSnapshot.initial);

  final FaceFramingDetector _detector;
  bool _processing = false;

  Future<void> onCameraImage(
    CameraImage image,
    CameraController controller,
  ) async {
    if (_processing) {
      return;
    }
    _processing = true;
    try {
      final next = await _detector.analyzeCameraFrame(
        image: image,
        controller: controller,
      );
      emit(next);
    } finally {
      _processing = false;
    }
  }

  void reset() {
    emit(FaceFramingSnapshot.initial);
  }

  @override
  Future<void> close() async {
    await _detector.dispose();
    return super.close();
  }
}
