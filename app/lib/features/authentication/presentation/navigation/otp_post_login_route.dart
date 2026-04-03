import 'package:app/core/config/app_router.gr.dart';
import 'package:app/core/enums/authentication/onboarding_step.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:auto_route/auto_route.dart';

/// Destino após OTP válido (login ou cadastro), conforme [UserEntity.onboardingStep] no Firestore.
PageRouteInfo<Object?> routeAfterOtpSuccess({UserEntity? userProfile}) {
  final step = userProfile?.onboardingStep;

  if (step == null) {
    return const SelfieSubmissionRoute();
  }

  switch (step) {
    case OnboardingStep.none:
    case OnboardingStep.selfie:
      return const SelfieSubmissionRoute();
    case OnboardingStep.permissions:
      return const NotificationPermissionRoute();
    case OnboardingStep.done:
      return const HomePlaceholderRoute();
    default:
      return const HomePlaceholderRoute();
  }
}
