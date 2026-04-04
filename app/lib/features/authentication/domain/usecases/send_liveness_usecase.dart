import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/liveness/data/dtos/liveness_dto.dart';
import 'package:app/features/liveness/domain/usecases/liveness_analysis_usecase.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/usecases/update_user_onboarding_step_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Orquestra análise de liveness e, se aprovada, avança o onboarding para permissões.
class SendLivenessUseCase {
  SendLivenessUseCase({
    required LivenessAnalysisUseCase livenessAnalysisUseCase,
    required UpdateUserOnboardingStepUseCase updateUserOnboardingStepUseCase,
  })  : _livenessAnalysisUseCase = livenessAnalysisUseCase,
        _updateUserOnboardingStepUseCase = updateUserOnboardingStepUseCase;

  final LivenessAnalysisUseCase _livenessAnalysisUseCase;
  final UpdateUserOnboardingStepUseCase _updateUserOnboardingStepUseCase;

  Future<Either<Failure, UserEntity>> call(LivenessDto capture) async {
    final analysis = await _livenessAnalysisUseCase(capture);
    return analysis.fold<Future<Either<Failure, UserEntity>>>(
      (failure) async => Left(failure),
      (result) async {
        if (!result.passed) {
          return Left(
            ValidationFailure(
              result.failureReason ?? 'Verificação não aprovada.',
            ),
          );
        }
        return _updateUserOnboardingStepUseCase(
          capture.userId.trim(),
          OnboardingStep.permissions,
        );
      },
    );
  }
}
