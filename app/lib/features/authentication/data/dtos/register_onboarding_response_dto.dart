import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/authentication/data/dtos/send_login_sms_response_dto.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart';

/// Resposta de [RegisterOnboardingUseCase] (SMS via [SendLoginSmsUseCase] + perfil salvo, se houver).
@immutable
class RegisterOnboardingResponseDto {
  const RegisterOnboardingResponseDto({
    required this.sms,
    this.createdUser,
    this.pendingOnboarding,
  });

  final SendLoginSmsResponseDto sms;
  final UserEntity? createdUser;

  /// Preenchido quando ainda falta OTP manual; usado em [VerifySmsOtpDto.pendingOnboarding].
  final OnboardingDto? pendingOnboarding;
}
