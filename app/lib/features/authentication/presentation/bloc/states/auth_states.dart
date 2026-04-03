import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/liveness_api_service.dart';
import 'package:app/features/authentication/data/dtos/register_onboarding_response_dto.dart';
import 'package:app/features/authentication/data/dtos/send_login_sms_response_dto.dart';
import 'package:app/features/authentication/data/dtos/verify_sms_otp_response_dto.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

/// Estados de autenticação / onboarding (um conjunto por caso de uso).
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado neutro (valor inicial do [AuthBloc]).
final class AuthInitial extends AuthState {
  const AuthInitial();
}

// —— VerifyCpfUseCase ——
final class VerifyCpfInitial extends AuthState {
  const VerifyCpfInitial();
}

final class VerifyCpfLoading extends AuthState {
  const VerifyCpfLoading();
}

final class VerifyCpfSuccess extends AuthState {
  const VerifyCpfSuccess({
    required this.exists,
    this.phoneNumber,
  });

  /// `true` se o CPF já existe no cadastro (retorno da callable).
  final bool exists;

  /// Celular associado ao usuário quando [exists] é `true`; senão `null`.
  final String? phoneNumber;

  @override
  List<Object?> get props => [exists, phoneNumber];
}

final class VerifyCpfError extends AuthState {
  const VerifyCpfError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— RegisterOnboardingUseCase ——
final class RegisterOnboardingInitial extends AuthState {
  const RegisterOnboardingInitial();
}

final class RegisterOnboardingLoading extends AuthState {
  const RegisterOnboardingLoading();
}

final class RegisterOnboardingSuccess extends AuthState {
  const RegisterOnboardingSuccess(this.data);

  final RegisterOnboardingResponseDto data;

  @override
  List<Object?> get props => [data];
}

final class RegisterOnboardingError extends AuthState {
  const RegisterOnboardingError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— VerifySmsOtpUseCase ——
final class VerifySmsOtpInitial extends AuthState {
  const VerifySmsOtpInitial();
}

final class VerifySmsOtpLoading extends AuthState {
  const VerifySmsOtpLoading();
}

final class VerifySmsOtpSuccess extends AuthState {
  const VerifySmsOtpSuccess(this.data);

  final VerifySmsOtpResponseDto data;

  @override
  List<Object?> get props => [data];
}

final class VerifySmsOtpError extends AuthState {
  const VerifySmsOtpError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— SendLoginSmsUseCase ——
final class SendLoginSmsInitial extends AuthState {
  const SendLoginSmsInitial();
}

final class SendLoginSmsLoading extends AuthState {
  const SendLoginSmsLoading();
}

final class SendLoginSmsSuccess extends AuthState {
  const SendLoginSmsSuccess(this.data);

  final SendLoginSmsResponseDto data;

  @override
  List<Object?> get props => [data];
}

final class SendLoginSmsError extends AuthState {
  const SendLoginSmsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— InitLivenessSessionUseCase ——
final class InitLivenessSessionInitial extends AuthState {
  const InitLivenessSessionInitial();
}

final class InitLivenessSessionLoading extends AuthState {
  const InitLivenessSessionLoading();
}

final class InitLivenessSessionSuccess extends AuthState {
  const InitLivenessSessionSuccess(this.result);

  final LivenessInitSessionResult result;

  @override
  List<Object?> get props => [result];
}

final class InitLivenessSessionError extends AuthState {
  const InitLivenessSessionError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— LivenessAnalysisUseCase ——
final class LivenessAnalysisInitial extends AuthState {
  const LivenessAnalysisInitial();
}

final class LivenessAnalysisLoading extends AuthState {
  const LivenessAnalysisLoading();
}

final class LivenessAnalysisSuccess extends AuthState {
  const LivenessAnalysisSuccess(this.result);

  final LivenessAnalysisResult result;

  @override
  List<Object?> get props => [result];
}

final class LivenessAnalysisError extends AuthState {
  const LivenessAnalysisError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— EnableCameraPermissionUseCase ——
final class EnableCameraPermissionInitial extends AuthState {
  const EnableCameraPermissionInitial();
}

final class EnableCameraPermissionLoading extends AuthState {
  const EnableCameraPermissionLoading();
}

final class EnableCameraPermissionSuccess extends AuthState {
  const EnableCameraPermissionSuccess();
}

final class EnableCameraPermissionError extends AuthState {
  const EnableCameraPermissionError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— EnableBiometricsUseCase ——
final class EnableBiometricsInitial extends AuthState {
  const EnableBiometricsInitial();
}

final class EnableBiometricsLoading extends AuthState {
  const EnableBiometricsLoading();
}

final class EnableBiometricsSuccess extends AuthState {
  const EnableBiometricsSuccess();
}

final class EnableBiometricsError extends AuthState {
  const EnableBiometricsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— EnableNotificationsUseCase ——
final class EnableNotificationsInitial extends AuthState {
  const EnableNotificationsInitial();
}

final class EnableNotificationsLoading extends AuthState {
  const EnableNotificationsLoading();
}

final class EnableNotificationsSuccess extends AuthState {
  const EnableNotificationsSuccess();
}

final class EnableNotificationsError extends AuthState {
  const EnableNotificationsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— EnableLocalizationUseCase ——
final class EnableLocalizationInitial extends AuthState {
  const EnableLocalizationInitial();
}

final class EnableLocalizationLoading extends AuthState {
  const EnableLocalizationLoading();
}

final class EnableLocalizationSuccess extends AuthState {
  const EnableLocalizationSuccess();
}

final class EnableLocalizationError extends AuthState {
  const EnableLocalizationError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

// —— SavePermissionsPreferencesUseCase ——
final class SavePermissionsPreferencesInitial extends AuthState {
  const SavePermissionsPreferencesInitial();
}

final class SavePermissionsPreferencesLoading extends AuthState {
  const SavePermissionsPreferencesLoading();
}

final class SavePermissionsPreferencesSuccess extends AuthState {
  const SavePermissionsPreferencesSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class SavePermissionsPreferencesError extends AuthState {
  const SavePermissionsPreferencesError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
