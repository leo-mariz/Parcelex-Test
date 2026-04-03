import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/liveness_api_service.dart';
import 'package:fpdart/fpdart.dart';

/// Inicia sessão de liveness via [LivenessApiService] (mock ou cliente real).
class InitLivenessSessionUseCase {
  InitLivenessSessionUseCase({required LivenessApiService livenessApi})
      : _livenessApi = livenessApi;

  final LivenessApiService _livenessApi;

  Future<Either<Failure, LivenessInitSessionResult>> call(String userId) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) {
      return const Left(
        ValidationFailure(
          'Identificador do usuário é obrigatório para iniciar o liveness.',
        ),
      );
    }

    try {
      final result = await _livenessApi.initLivenessSession(trimmed);
      return Right(result);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
