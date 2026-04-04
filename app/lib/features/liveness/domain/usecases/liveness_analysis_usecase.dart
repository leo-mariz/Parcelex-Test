import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/liveness_api_service.dart';
import 'package:app/features/liveness/data/dtos/liveness_dto.dart';
import 'package:fpdart/fpdart.dart';

/// Envia captura de liveness para [LivenessApiService] (mock ou cliente real).
class LivenessAnalysisUseCase {
  LivenessAnalysisUseCase({required LivenessApiService livenessApi})
      : _livenessApi = livenessApi;

  final LivenessApiService _livenessApi;

  Future<Either<Failure, LivenessAnalysisResult>> call(
    LivenessDto capture,
  ) async {
    if (capture.userId.trim().isEmpty) {
      return const Left(
        ValidationFailure(
          'Identificador do usuário é obrigatório para análise de liveness.',
        ),
      );
    }

    try {
      final result = await _livenessApi.analyzeLiveness(capture);
      return Right(result);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
