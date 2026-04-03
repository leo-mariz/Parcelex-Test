import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:app/features/permissions/domain/usecases/permissions_from_dto.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/usecases/get_user_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_onboarding_step_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Persiste de uma vez o agregado de permissões (notificação, biometria, localização).
class UpdateUserPermissionsUseCase {
  UpdateUserPermissionsUseCase({
    required AuthService authService,
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required UpdateUserOnboardingStepUseCase updateUserOnboardingStepUseCase,
  })  : _auth = authService,
        _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _updateUserOnboardingStepUseCase = updateUserOnboardingStepUseCase;

  final AuthService _auth;
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final UpdateUserOnboardingStepUseCase _updateUserOnboardingStepUseCase;

  Future<Either<Failure, UserEntity>> call(PermissionsDto dto) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Left(AuthFailure('Usuário não autenticado.'));
    }

    final currentRes = await _getUserUseCase.call(uid);
    switch (currentRes) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final current):
        if (current == null) {
          return const Left(NotFoundFailure('Perfil não encontrado.'));
        }
        final prompts = permissionStateFromDto(dto);
        final updated = current.copyWith(
          permissionPrompts: prompts,
          updatedAt: DateTime.now(),
        );
        final updateOnboardingStepResult = await _updateUserOnboardingStepUseCase.call(current.id!, OnboardingStep.done);
        switch (updateOnboardingStepResult) {
          case Left(value: final failure):
            return Left(failure);
          case Right(value: _):
            return _updateUserUseCase.call(updated);
        }
    }
  }
}
