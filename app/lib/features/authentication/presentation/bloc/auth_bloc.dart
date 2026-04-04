import 'package:app/core/errors/failures.dart';
import 'package:app/features/authentication/domain/usecases/get_user_uid_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_biometrics_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_camera_permission_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_localization_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_notifications_usecase.dart';
import 'package:app/features/liveness/domain/usecases/init_liveness_session_usecase.dart';
import 'package:app/features/authentication/domain/usecases/send_liveness_usecase.dart';
import 'package:app/features/authentication/domain/usecases/register_onboarding_usecase.dart';
import 'package:app/features/authentication/domain/usecases/send_login_sms_usecase.dart';
import 'package:app/features/authentication/domain/usecases/save_permissions_preferences_usecase.dart';
import 'package:app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:app/features/authentication/domain/usecases/verify_cpf_usecase.dart';
import 'package:app/features/authentication/domain/usecases/verify_sms_otp_usecase.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:app/features/authentication/presentation/bloc/states/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.verifyCpfUseCase,
    required this.registerOnboardingUseCase,
    required this.verifySmsOtpUseCase,
    required this.sendLoginSmsUseCase,
    required this.getUserUidUseCase,
    required this.initLivenessSessionUseCase,
    required this.sendLivenessUseCase,
    required this.enableCameraPermissionUseCase,
    required this.enableBiometricsUseCase,
    required this.enableNotificationsUseCase,
    required this.enableLocalizationUseCase,
    required this.savePermissionsPreferencesUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<VerifyCpfSubmitted>(_onVerifyCpfSubmitted);
    on<VerifyCpfReset>(_onVerifyCpfReset);
    on<RegisterOnboardingSubmitted>(_onRegisterOnboardingSubmitted);
    on<RegisterOnboardingReset>(_onRegisterOnboardingReset);
    on<VerifySmsOtpSubmitted>(_onVerifySmsOtpSubmitted);
    on<VerifySmsOtpReset>(_onVerifySmsOtpReset);
    on<SendLoginSmsSubmitted>(_onSendLoginSmsSubmitted);
    on<SendLoginSmsReset>(_onSendLoginSmsReset);
    on<InitLivenessSessionRequested>(_onInitLivenessSessionRequested);
    on<InitLivenessSessionReset>(_onInitLivenessSessionReset);
    on<SendLivenessRequested>(_onSendLivenessRequested);
    on<SendLivenessReset>(_onSendLivenessReset);
    on<EnableCameraPermissionRequested>(_onEnableCameraPermissionRequested);
    on<EnableCameraPermissionReset>(_onEnableCameraPermissionReset);
    on<EnableBiometricsRequested>(_onEnableBiometricsRequested);
    on<EnableBiometricsReset>(_onEnableBiometricsReset);
    on<EnableNotificationsRequested>(_onEnableNotificationsRequested);
    on<EnableNotificationsReset>(_onEnableNotificationsReset);
    on<EnableLocalizationRequested>(_onEnableLocalizationRequested);
    on<EnableLocalizationReset>(_onEnableLocalizationReset);
    on<SavePermissionsPreferencesSubmitted>(
      _onSavePermissionsPreferencesSubmitted,
    );
    on<SavePermissionsPreferencesReset>(_onSavePermissionsPreferencesReset);
    on<LogoutRequested>(_onLogoutRequested);
    on<LogoutReset>(_onLogoutReset);
  }

  final VerifyCpfUseCase verifyCpfUseCase;
  final RegisterOnboardingUseCase registerOnboardingUseCase;
  final VerifySmsOtpUseCase verifySmsOtpUseCase;
  final SendLoginSmsUseCase sendLoginSmsUseCase;
  final GetUserUidUseCase getUserUidUseCase;
  final InitLivenessSessionUseCase initLivenessSessionUseCase;
  final SendLivenessUseCase sendLivenessUseCase;
  final EnableCameraPermissionUseCase enableCameraPermissionUseCase;
  final EnableBiometricsUseCase enableBiometricsUseCase;
  final EnableNotificationsUseCase enableNotificationsUseCase;
  final EnableLocalizationUseCase enableLocalizationUseCase;
  final SavePermissionsPreferencesUseCase savePermissionsPreferencesUseCase;
  final LogoutUseCase logoutUseCase;

  // —— VerifyCpf ——————————————————————————————————————————————————

  Future<void> _onVerifyCpfSubmitted(
    VerifyCpfSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const VerifyCpfLoading());

    final result = await verifyCpfUseCase.call(event.dto);

    result.fold(
      (failure) {
        emit(VerifyCpfError(failure));
        emit(const VerifyCpfInitial());
      },
      (data) {
        emit(
          VerifyCpfSuccess(
            exists: data.exists,
            phoneNumber: data.phoneNumber,
          ),
        );
      },
    );
  }

  void _onVerifyCpfReset(
    VerifyCpfReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const VerifyCpfInitial());
  }

  // —— RegisterOnboarding —————————————————————————————————————————

  Future<void> _onRegisterOnboardingSubmitted(
    RegisterOnboardingSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const RegisterOnboardingLoading());

    final result = await registerOnboardingUseCase.call(event.dto);

    result.fold(
      (failure) {
        emit(RegisterOnboardingError(failure));
        emit(const RegisterOnboardingInitial());
      },
      (data) {
        emit(RegisterOnboardingSuccess(data));
      },
    );
  }

  void _onRegisterOnboardingReset(
    RegisterOnboardingReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const RegisterOnboardingInitial());
  }

  // —— VerifySmsOtp ———————————————————————————————————————————————

  Future<void> _onVerifySmsOtpSubmitted(
    VerifySmsOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const VerifySmsOtpLoading());

    final result = await verifySmsOtpUseCase.call(event.dto);

    result.fold(
      (failure) {
        emit(VerifySmsOtpError(failure));
        emit(const VerifySmsOtpInitial());
      },
      (data) {
        emit(VerifySmsOtpSuccess(data));
      },
    );
  }

  void _onVerifySmsOtpReset(
    VerifySmsOtpReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const VerifySmsOtpInitial());
  }

  // —— SendLoginSms —————————————————————————————————————————————————

  Future<void> _onSendLoginSmsSubmitted(
    SendLoginSmsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const SendLoginSmsLoading());

    final result = await sendLoginSmsUseCase.call(
      event.phoneNumberE164,
      forceResendingToken: event.forceResendingToken,
    );

    result.fold(
      (failure) {
        emit(SendLoginSmsError(failure));
        emit(const SendLoginSmsInitial());
      },
      (data) {
        emit(SendLoginSmsSuccess(data));
      },
    );
  }

  void _onSendLoginSmsReset(
    SendLoginSmsReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const SendLoginSmsInitial());
  }

  // —— InitLivenessSession ————————————————————————————————————————

  Future<Either<Failure, String>> _getUserUid() => getUserUidUseCase.call();

  Future<void> _onInitLivenessSessionRequested(
    InitLivenessSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const InitLivenessSessionLoading());

    final uidResult = await _getUserUid();
    await uidResult.fold(
      (failure) async {
        emit(InitLivenessSessionError(failure));
      },
      (uid) async {
        final sessionResult = await initLivenessSessionUseCase.call(uid);
        sessionResult.fold(
          (failure) {
            emit(InitLivenessSessionError(failure));
          },
          (data) {
            emit(InitLivenessSessionSuccess(data));
          },
        );
      },
    );
  }

  void _onInitLivenessSessionReset(
    InitLivenessSessionReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const InitLivenessSessionInitial());
  }

  // —— SendLiveness ——————————————————————————————————————————————

  Future<void> _onSendLivenessRequested(
    SendLivenessRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const SendLivenessLoading());

    final result = await sendLivenessUseCase.call(event.dto);

    result.fold(
      (failure) {
        emit(SendLivenessError(failure));
      },
      (user) {
        emit(SendLivenessSuccess(user));
      },
    );
  }

  void _onSendLivenessReset(
    SendLivenessReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const SendLivenessInitial());
  }

  // —— EnableCameraPermission —————————————————————————————————————

  Future<void> _onEnableCameraPermissionRequested(
    EnableCameraPermissionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const EnableCameraPermissionLoading());

    final result = await enableCameraPermissionUseCase.call();

    result.fold(
      (failure) {
        emit(EnableCameraPermissionError(failure));
        emit(const EnableCameraPermissionInitial());
      },
      (_) {
        emit(const EnableCameraPermissionSuccess());
      },
    );
  }

  void _onEnableCameraPermissionReset(
    EnableCameraPermissionReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const EnableCameraPermissionInitial());
  }

  // —— EnableBiometrics ———————————————————————————————————————————

  Future<void> _onEnableBiometricsRequested(
    EnableBiometricsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const EnableBiometricsLoading());

    final result = await enableBiometricsUseCase.call();

    result.fold(
      (failure) {
        emit(EnableBiometricsError(failure));
        emit(const EnableBiometricsInitial());
      },
      (_) {
        emit(const EnableBiometricsSuccess());
        emit(const EnableBiometricsInitial());
      },
    );
  }

  void _onEnableBiometricsReset(
    EnableBiometricsReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const EnableBiometricsInitial());
  }

  // —— EnableNotifications ————————————————————————————————————————

  Future<void> _onEnableNotificationsRequested(
    EnableNotificationsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const EnableNotificationsLoading());

    final result = await enableNotificationsUseCase.call();

    result.fold(
      (failure) {
        emit(EnableNotificationsError(failure));
        emit(const EnableNotificationsInitial());
      },
      (_) {
        emit(const EnableNotificationsSuccess());
        emit(const EnableNotificationsInitial());
      },
    );
  }

  void _onEnableNotificationsReset(
    EnableNotificationsReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const EnableNotificationsInitial());
  }

  // —— EnableLocalization ———————————————————————————————————————————

  Future<void> _onEnableLocalizationRequested(
    EnableLocalizationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const EnableLocalizationLoading());

    final result = await enableLocalizationUseCase.call();

    result.fold(
      (failure) {
        emit(EnableLocalizationError(failure));
        emit(const EnableLocalizationInitial());
      },
      (_) {
        emit(const EnableLocalizationSuccess());
        emit(const EnableLocalizationInitial());
      },
    );
  }

  void _onEnableLocalizationReset(
    EnableLocalizationReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const EnableLocalizationInitial());
  }

  // —— SavePermissionsPreferences ———————————————————————————————————

  Future<void> _onSavePermissionsPreferencesSubmitted(
    SavePermissionsPreferencesSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const SavePermissionsPreferencesLoading());

    final result = await savePermissionsPreferencesUseCase.call(event.dto);

    result.fold(
      (failure) {
        emit(SavePermissionsPreferencesError(failure));
        emit(const SavePermissionsPreferencesInitial());
      },
      (user) {
        emit(SavePermissionsPreferencesSuccess(user));
      },
    );
  }

  void _onSavePermissionsPreferencesReset(
    SavePermissionsPreferencesReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const SavePermissionsPreferencesInitial());
  }

  // —— Logout ——————————————————————————————————————————————————————

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LogoutLoading());

    final result = await logoutUseCase.call();

    result.fold(
      (failure) {
        emit(LogoutError(failure));
        emit(const AuthInitial());
      },
      (_) => emit(const LogoutSuccess()),
    );
  }

  void _onLogoutReset(
    LogoutReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }
}
