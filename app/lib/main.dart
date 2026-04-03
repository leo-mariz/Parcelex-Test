import 'package:app/core/config/bloc_factories.dart';
import 'package:app/core/config/setup_locator.dart';
import 'package:app/core/services/auth_functions.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/core/services/auto_cache_services.dart';
import 'package:app/core/services/biometrics_services.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/users/data/datasources/user_local_data_source.dart';
import 'package:app/features/users/data/datasources/user_remote_data_source.dart';
import 'package:app/features/users/data/repositories/user_repository_impl.dart';
import 'package:app/features/users/domain/usecases/create_user_usecase.dart';
import 'package:app/features/users/domain/usecases/get_user_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_onboarding_step_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_permissions_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_usecase.dart';
import 'package:app/features/users/presentation/bloc/users_bloc.dart';
import 'package:app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_cache/flutter_auto_cache.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_router.dart';
import 'core/presentation/app_scaffold_messenger.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/presentation/widgets/dismiss_keyboard_on_tap.dart';


final _appRouter = AppRouter();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AutoCacheInitializer.initialize();
  setupLocator();

  final firestore = getIt<FirebaseFirestore>();
  final localCacheService = getIt<ILocalCacheService>();

  final userRemote = UserRemoteDataSourceImpl(
    firestore,
  );
  final userLocal = UserLocalDataSourceImpl(
    localCacheService,
  );
  final userRepository = UserRepositoryImpl(
    local: userLocal,
    remote: userRemote,
  );

  final getUserUseCase = GetUserUseCase(userRepository: userRepository);
  final createUserUseCase = CreateUserUseCase(userRepository: userRepository);
  final updateUserUseCase = UpdateUserUseCase(userRepository: userRepository);
  final updateUserOnboardingStepUseCase = UpdateUserOnboardingStepUseCase(
    getUserUseCase: getUserUseCase,
    updateUserUseCase: updateUserUseCase,
  );
  final updateUserPermissionsUseCase = UpdateUserPermissionsUseCase(
    authService: getIt<AuthService>(),
    getUserUseCase: getUserUseCase,
    updateUserUseCase: updateUserUseCase,
  );
  final usersBloc = createUsersBloc(
    updateUserOnboardingStepUseCase: updateUserOnboardingStepUseCase,
    updateUserPermissionsUseCase: updateUserPermissionsUseCase,
  );

  final authBloc = createAuthBloc(
    authService: getIt<AuthService>(),
    getUserUseCase: getUserUseCase,
    createUserUseCase: createUserUseCase,
    updateUserUseCase: updateUserUseCase,
    updateUserPermissionsUseCase: updateUserPermissionsUseCase,
    biometrics: getIt<IBiometricAuthService>(),
    authFunctions: getIt<AuthFunctionsService>(),
  );

  runApp(ParcelexApp(authBloc: authBloc, usersBloc: usersBloc));
}

class ParcelexApp extends StatelessWidget {
  const ParcelexApp({
    super.key,
    required this.authBloc,
    required this.usersBloc,
  });

  final AuthBloc authBloc;
  final UsersBloc usersBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<UsersBloc>.value(value: usersBloc),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: appScaffoldMessengerKey,
        title: 'Parceleo',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: _appRouter.config(),
        builder: (context, child) {
          return DismissKeyboardOnTap(child: child);
        },
      ),
    );
  }
}
