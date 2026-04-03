import 'package:flutter/foundation.dart';

import 'onboarding_dto.dart';

/// Entrada de [VerifySmsOtpUseCase] (Firebase Phone Auth).
@immutable
class VerifySmsOtpDto {
  const VerifySmsOtpDto({
    required this.verificationId,
    required this.smsCode,
    this.pendingOnboarding,
  });

  final String verificationId;
  final String smsCode;

  /// Se preenchido, após o login o perfil é persistido em [UserRepository].
  final OnboardingDto? pendingOnboarding;
}
