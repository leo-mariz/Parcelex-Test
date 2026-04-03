import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/usecases/get_user_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';

class UpdateUserOnboardingStepUseCase {
  UpdateUserOnboardingStepUseCase({required GetUserUseCase getUserUseCase, required UpdateUserUseCase updateUserUseCase})
      : _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase;

  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  Future<Either<Failure, UserEntity>> call(String id, OnboardingStep onboardingStep) async {
    if (kDebugMode) {
      debugPrint(
        '[UpdateUserOnboardingStep] início id="$id" (vazio=${id.isEmpty}) '
        'step=$onboardingStep',
      );
    }

    final userResult = await _getUserUseCase.call(id);
    switch (userResult) {
      case Left(value: final failure):
        if (kDebugMode) {
          debugPrint(
            '[UpdateUserOnboardingStep] GetUser falhou: '
            '${failure.runtimeType} → ${failure.message}',
          );
        }
        return Left(failure);
      case Right(value: final user):
        if (user == null) {
          if (kDebugMode) {
            debugPrint(
              '[UpdateUserOnboardingStep] GetUser retornou Right(null): '
              'nenhum documento/cache para id="$id" (ver logs UserRepository.getById).',
            );
          }
          return Left(NotFoundFailure('Usuário não encontrado.'));
        }
        if (kDebugMode) {
          debugPrint(
            '[UpdateUserOnboardingStep] usuário encontrado id=${user.id} '
            'email=${user.email} stepAtual=${user.onboardingStep} → novo=$onboardingStep',
          );
        }
        final updatedUser = user.copyWith(onboardingStep: onboardingStep);
        final updateResult = await _updateUserUseCase.call(updatedUser);
        if (kDebugMode) {
          updateResult.fold(
            (f) => debugPrint(
              '[UpdateUserOnboardingStep] UpdateUser falhou: '
              '${f.runtimeType} → ${f.message}',
            ),
            (u) => debugPrint(
              '[UpdateUserOnboardingStep] UpdateUser ok id=${u.id} step=${u.onboardingStep}',
            ),
          );
        }
        return updateResult;
    }
  }
}
