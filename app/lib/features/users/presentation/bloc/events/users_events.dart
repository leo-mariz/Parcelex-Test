import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:equatable/equatable.dart';

/// Eventos do [UsersBloc] (por caso de uso).
sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

// —— UpdateUserOnboardingStepUseCase ——
final class UpdateUserOnboardingStepSubmitted extends UsersEvent {
  const UpdateUserOnboardingStepSubmitted({
    required this.userId,
    required this.onboardingStep,
  });

  final String userId;
  final OnboardingStep onboardingStep;

  @override
  List<Object?> get props => [userId, onboardingStep];
}

final class UpdateUserOnboardingStepReset extends UsersEvent {
  const UpdateUserOnboardingStepReset();
}

// —— UpdateUserPermissionsUseCase ——

final class UpdateUserPermissionsSubmitted extends UsersEvent {
  const UpdateUserPermissionsSubmitted(this.dto);

  final PermissionsDto dto;

  @override
  List<Object?> get props => [dto.notification, dto.location, dto.biometric];
}

final class UpdateUserPermissionsReset extends UsersEvent {
  const UpdateUserPermissionsReset();
}
