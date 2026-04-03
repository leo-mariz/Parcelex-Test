import 'package:app/features/authentication/data/dtos/liveness_dto.dart';
import 'package:app/features/authentication/data/dtos/login_dto.dart';
import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:app/features/authentication/data/dtos/verify_sms_otp_dto.dart';
import 'package:equatable/equatable.dart';

/// Eventos de autenticação / onboarding (um conjunto por caso de uso).
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// —— VerifyCpfUseCase ——
final class VerifyCpfSubmitted extends AuthEvent {
  const VerifyCpfSubmitted(this.dto);

  final LoginDto dto;

  @override
  List<Object?> get props => [dto];
}

final class VerifyCpfReset extends AuthEvent {
  const VerifyCpfReset();
}

// —— RegisterOnboardingUseCase ——
final class RegisterOnboardingSubmitted extends AuthEvent {
  const RegisterOnboardingSubmitted(this.dto);

  final OnboardingDto dto;

  @override
  List<Object?> get props => [dto];
}

final class RegisterOnboardingReset extends AuthEvent {
  const RegisterOnboardingReset();
}

// —— VerifySmsOtpUseCase ——
final class VerifySmsOtpSubmitted extends AuthEvent {
  const VerifySmsOtpSubmitted(this.dto);

  final VerifySmsOtpDto dto;

  @override
  List<Object?> get props => [dto];
}

final class VerifySmsOtpReset extends AuthEvent {
  const VerifySmsOtpReset();
}

// —— SendLoginSmsUseCase ——
final class SendLoginSmsSubmitted extends AuthEvent {
  const SendLoginSmsSubmitted(
    this.phoneNumberE164, {
    this.forceResendingToken,
  });

  /// Telefone em E.164 (ex.: `+5511999998888`).
  final String phoneNumberE164;

  /// Token do Firebase para reenvio de SMS após o primeiro envio.
  final int? forceResendingToken;

  @override
  List<Object?> get props => [phoneNumberE164, forceResendingToken];
}

final class SendLoginSmsReset extends AuthEvent {
  const SendLoginSmsReset();
}

// —— InitLivenessSessionUseCase ——
final class InitLivenessSessionRequested extends AuthEvent {
  const InitLivenessSessionRequested();
}

final class InitLivenessSessionReset extends AuthEvent {
  const InitLivenessSessionReset();
}

// —— LivenessAnalysisUseCase ——
final class LivenessAnalysisRequested extends AuthEvent {
  const LivenessAnalysisRequested(this.dto);

  final LivenessDto dto;

  @override
  List<Object?> get props => [dto];
}

final class LivenessAnalysisReset extends AuthEvent {
  const LivenessAnalysisReset();
}

// —— EnableCameraPermissionUseCase ——
final class EnableCameraPermissionRequested extends AuthEvent {
  const EnableCameraPermissionRequested();
}

final class EnableCameraPermissionReset extends AuthEvent {
  const EnableCameraPermissionReset();
}

// —— EnableBiometricsUseCase ——
final class EnableBiometricsRequested extends AuthEvent {
  const EnableBiometricsRequested();
}

final class EnableBiometricsReset extends AuthEvent {
  const EnableBiometricsReset();
}

// —— EnableNotificationsUseCase ——
final class EnableNotificationsRequested extends AuthEvent {
  const EnableNotificationsRequested();
}

final class EnableNotificationsReset extends AuthEvent {
  const EnableNotificationsReset();
}

// —— EnableLocalizationUseCase ——
final class EnableLocalizationRequested extends AuthEvent {
  const EnableLocalizationRequested();
}

final class EnableLocalizationReset extends AuthEvent {
  const EnableLocalizationReset();
}

// —— SavePermissionsPreferencesUseCase ——
final class SavePermissionsPreferencesSubmitted extends AuthEvent {
  const SavePermissionsPreferencesSubmitted(this.dto);

  final PermissionsDto dto;

  @override
  List<Object?> get props => [dto];
}

final class SavePermissionsPreferencesReset extends AuthEvent {
  const SavePermissionsPreferencesReset();
}
