import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';

/// Perfil a partir do formulário; [UserEntity.id] fica nulo até [CreateUserUseCase] receber o UID do Auth.
UserEntity userEntityFromOnboardingDto({
  required OnboardingDto dto,
}) {
  final now = DateTime.now();
  return UserEntity(
    id: null,
    email: dto.email,
    phoneNumber: dto.phoneDigits,
    fullName: dto.fullName,
    onboardingStep: OnboardingStep.profileComplete,
    cpf: dto.cpfDigits,
    createdAt: now,
    updatedAt: now,
  );
}
