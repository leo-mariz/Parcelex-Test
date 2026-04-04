import 'package:app/core/presentation/notifications/app_notifications_controller.dart';
import 'package:app/core/services/auth_functions.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/core/services/face_framing_detector.dart';
import 'package:app/core/services/liveness_api_service.dart';
import 'package:app/core/services/auto_cache_services.dart';
import 'package:app/core/services/biometrics_services.dart';
import 'package:app/core/services/connectivity_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';

final getIt = GetIt.instance;

/// Serviços e infra compartilhada. Datasources, repositórios, use cases e Blocs
/// são montados no [main] (ver [createAuthBloc] em `bloc_factories.dart`).
void setupLocator() {
  getIt.registerLazySingleton<AppNotificationsController>(
    AppNotificationsController.new,
  );

  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(FirebaseAuth.instance),
  );

  getIt.registerLazySingleton<ILocalCacheService>(
    () => AutoCacheServiceImplementation(),
  );

  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );

  getIt.registerLazySingleton<ConnectionBloc>(
    () => ConnectionBloc(getIt<InternetConnectionChecker>()),
  );

  getIt.registerLazySingleton<LocalAuthentication>(
    () => LocalAuthentication(),
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<IBiometricAuthService>(
    () => BiometricAuthServiceImpl(
      localAuth: getIt<LocalAuthentication>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<AuthFunctionsService>(
    FirebaseAuthFunctionsService.new,
  );

  getIt.registerLazySingleton<LivenessApiService>(LivenessApiMockService.new);

  /// Nova instância por fluxo (o [FaceFramingCubit] chama [dispose] ao fechar).
  getIt.registerFactory<FaceFramingDetector>(MlKitFaceFramingDetector.new);
}
