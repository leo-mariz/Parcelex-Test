# Serviços em `lib/core/services/`

Arquivos nesta pasta são **infraestrutura compartilhada**: autenticação Firebase, funções callable, cache local, biometria, cliente de liveness, detecção facial para enquadramento e conectividade. A relação **interface → implementação** e o registro no `GetIt` estão detalhados em [architecture/inversao-de-dependencia.md](architecture/inversao-de-dependencia.md).

## `auth_services.dart`

- **`AuthService`** — contrato para sessão Firebase (`currentUser`, `authStateChanges`, `logout`, SMS `signInWithSms`, `verifySmsOtp`, token, `reloadCurrentUser`).
- **`FirebaseAuthService`** — implementação com `FirebaseAuth`.
- **`SmsSignInChallenge`** — modela envio de SMS: fluxo que exige OTP manual vs. login automático (comum no Android).

## `auth_functions.dart`

- **`AuthFunctionsService`** — callable HTTPS (região `southamerica-east1`): `checkCpfExists`.
- **`FirebaseAuthFunctionsService`** — implementação com `FirebaseFunctions.instanceFor(region: …)`.
- **`CheckCpfExistsResult`** — `exists` + `phoneNumber` em E.164 quando aplicável.

## `auto_cache_services.dart`

- **`ILocalCacheService`** — persistência de mapas JSON por chave (salvar, ler, apagar, limpar). Erros viram `CacheException`.
- **`AutoCacheServiceImplementation`** — delega ao pacote `flutter_auto_cache`.

Usado pelo **`UserLocalDataSourceImpl`** para cache de `UserEntity`.

## `biometrics_services.dart`

- **`IBiometricAuthService`** — disponibilidade de biometria, autenticação, habilitar/desabilitar, credenciais no secure storage quando aplicável, e `enableBiometricsWithoutStoredCredentials` para fluxo OTP.
- **`BiometricAuthServiceImpl`** — `LocalAuthentication` + `FlutterSecureStorage`.

## `liveness_api_service.dart`

- **`LivenessApiService`** — `initLivenessSession` e `analyzeLiveness(LivenessDto)`.
- **`LivenessInitSessionResult`**, **`LivenessAnalysisResult`** — DTOs de resposta.
- **`LivenessApiMockService`** — atrasos configuráveis e `forceAnalysisFailure` para testes; substituir por implementação real quando o backend estiver disponível.

## `face_framing_detector.dart`

- **`FaceFramingDetector`** — `analyzeCameraFrame` + `dispose` (interface).
- **`MlKitFaceFramingDetector`** — Google ML Kit Face Detection a partir de `CameraImage` (NV21 / BGRA conforme plataforma).

Registrado como **factory** no `GetIt`: uma instância por fluxo; o `FaceFramingCubit` chama `dispose` ao encerrar.

## `connectivity_services.dart`

- **`ConnectionBloc`** (`Cubit<ConnectionState>`) — escuta `InternetConnectionChecker.onStatusChange` e emite `connected` / `disconnected`.

Não há interface própria; o Cubit depende diretamente de `InternetConnectionChecker`.

## Outros pontos em `core` (não são “services” nesta pasta)

- Permissões de câmera / notificação / localização: `lib/core/permissions/` (funções e helpers usados pelos use cases de `features/permissions`).
- Notificações de UI: `lib/core/presentation/notifications/` (`AppNotificationsController`, etc.).
