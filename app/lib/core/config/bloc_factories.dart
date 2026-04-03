import 'package:app/core/config/setup_locator.dart';
import 'package:app/core/services/auth_functions.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/core/services/biometrics_services.dart';
import 'package:app/core/services/liveness_api_service.dart';
import 'package:app/features/permissions/domain/usecases/enable_biometrics_usecase.dart';
import 'package:app/features/authentication/domain/usecases/get_user_uid_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_camera_permission_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_localization_usecase.dart';
import 'package:app/features/permissions/domain/usecases/enable_notifications_usecase.dart';
import 'package:app/features/authentication/domain/usecases/init_liveness_session_usecase.dart';
import 'package:app/features/authentication/domain/usecases/liveness_analysis_usecase.dart';
import 'package:app/features/authentication/domain/usecases/register_onboarding_usecase.dart';
import 'package:app/features/authentication/domain/usecases/send_login_sms_usecase.dart';
import 'package:app/features/authentication/domain/usecases/save_permissions_preferences_usecase.dart';
import 'package:app/features/authentication/domain/usecases/verify_cpf_usecase.dart';
import 'package:app/features/authentication/domain/usecases/verify_sms_otp_usecase.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/users/domain/usecases/create_user_usecase.dart';
import 'package:app/features/users/domain/usecases/get_user_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_onboarding_step_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_permissions_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_usecase.dart';
import 'package:app/features/users/presentation/bloc/users_bloc.dart';

/// Fábricas de Blocs: instanciam use cases a partir de contratos já montados no [main].
AuthBloc createAuthBloc({
  required AuthService authService,
  required IBiometricAuthService biometrics,
  required AuthFunctionsService authFunctions,
  required GetUserUseCase getUserUseCase,
  required CreateUserUseCase createUserUseCase,
  required UpdateUserUseCase updateUserUseCase,
  required UpdateUserPermissionsUseCase updateUserPermissionsUseCase,
}) {
  final verifyCpfUseCase = VerifyCpfUseCase(
    authFunctions: authFunctions,
  );
  final sendLoginSmsUseCase = SendLoginSmsUseCase(authService: authService);
  final registerOnboardingUseCase = RegisterOnboardingUseCase(
    sendLoginSmsUseCase: sendLoginSmsUseCase,
    createUserUseCase: createUserUseCase,
  );
  final verifySmsOtpUseCase = VerifySmsOtpUseCase(
    authService: authService,
    getUserUseCase: getUserUseCase,
    createUserUseCase: createUserUseCase,
  );
  final getUserUidUseCase = GetUserUidUseCase(authService: authService);
  final initLivenessSessionUseCase = InitLivenessSessionUseCase(
    livenessApi: getIt<LivenessApiService>(),
  );
  final livenessAnalysisUseCase = LivenessAnalysisUseCase(
    livenessApi: getIt<LivenessApiService>(),
  );
  final enableCameraPermissionUseCase = EnableCameraPermissionUseCase();
  final enableBiometricsUseCase = EnableBiometricsUseCase(
    biometrics: biometrics,
  );
  final enableNotificationsUseCase = EnableNotificationsUseCase();
  final enableLocalizationUseCase = EnableLocalizationUseCase();
  final savePermissionsPreferencesUseCase = SavePermissionsPreferencesUseCase(
    updateUserPermissionsUseCase: updateUserPermissionsUseCase,
  );

  return AuthBloc(
    verifyCpfUseCase: verifyCpfUseCase,
    registerOnboardingUseCase: registerOnboardingUseCase,
    verifySmsOtpUseCase: verifySmsOtpUseCase,
    sendLoginSmsUseCase: sendLoginSmsUseCase,
    getUserUidUseCase: getUserUidUseCase,
    initLivenessSessionUseCase: initLivenessSessionUseCase,
    livenessAnalysisUseCase: livenessAnalysisUseCase,
    enableCameraPermissionUseCase: enableCameraPermissionUseCase,
    enableBiometricsUseCase: enableBiometricsUseCase,
    enableNotificationsUseCase: enableNotificationsUseCase,
    enableLocalizationUseCase: enableLocalizationUseCase,
    savePermissionsPreferencesUseCase: savePermissionsPreferencesUseCase,
  );
}

UsersBloc createUsersBloc({
  required UpdateUserOnboardingStepUseCase updateUserOnboardingStepUseCase,
  required UpdateUserPermissionsUseCase updateUserPermissionsUseCase,
}) {
  return UsersBloc(
    updateUserOnboardingStepUseCase: updateUserOnboardingStepUseCase,
    updateUserPermissionsUseCase: updateUserPermissionsUseCase,
  );
}
