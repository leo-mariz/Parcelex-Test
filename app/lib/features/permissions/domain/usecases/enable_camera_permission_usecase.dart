import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/permissions/camera_permission.dart';
import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';

/// Solicita permissão de câmera via [requestCameraPermission].
class EnableCameraPermissionUseCase {
  EnableCameraPermissionUseCase();

  Future<Either<Failure, Unit>> call() async {
    try {
      final status = await requestCameraPermission();
      switch (status) {
        case PermissionStatus.granted:
        case PermissionStatus.limited:
          return const Right(unit);
        case PermissionStatus.denied:
          return const Left(
            PermissionFailure(
              'Permissão da câmera negada. Tente de novo ou habilite nas configurações do aparelho.',
            ),
          );
        case PermissionStatus.permanentlyDenied:
          return const Left(
            PermissionFailure(
              'Permissão da câmera bloqueada. Habilite nas configurações do aparelho para continuar.',
            ),
          );
        case PermissionStatus.restricted:
          return const Left(
            PermissionFailure(
              'Câmera indisponível por restrições neste dispositivo.',
            ),
          );
        case PermissionStatus.provisional:
          return const Left(
            PermissionFailure(
              'Não foi possível obter permissão da câmera.',
            ),
          );
      }
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
