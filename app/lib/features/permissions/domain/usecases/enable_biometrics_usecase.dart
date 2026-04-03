import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/biometrics_services.dart';
import 'package:fpdart/fpdart.dart';

/// Confirma biometria no dispositivo e marca o app como “acesso rápido” habilitado
/// (sem armazenar senha — login é por telefone/OTP).
class EnableBiometricsUseCase {
  EnableBiometricsUseCase({
    required IBiometricAuthService biometrics,
  }) : _biometrics = biometrics;

  final IBiometricAuthService _biometrics;

  Future<Either<Failure, Unit>> call() async {
    try {
      if (!await _biometrics.isBiometricsAvailable()) {
        return const Left(
          ValidationFailure(
            'Biometria indisponível ou não configurada neste aparelho.',
          ),
        );
      }
      final ok = await _biometrics.authenticateWithBiometrics();
      if (!ok) {
        return const Left(
          ValidationFailure('Autenticação biométrica não concluída.'),
        );
      }
      await _biometrics.enableBiometricsWithoutStoredCredentials();
      return const Right(unit);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
