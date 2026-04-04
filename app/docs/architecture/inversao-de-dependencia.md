# Inversão de dependência no app

O código segue o padrão em que **camadas internas dependem de abstrações** (interfaces / classes abstratas), e **implementações concretas** ficam em `data/`, `core/services/` ou são injetadas na composição raiz (`main.dart`, `setup_locator.dart`, `bloc_factories.dart`).

## O que isso significa na prática

1. **Domínio** (`domain/`) declara contratos estáveis — por exemplo `UserRepository`, ou use cases que recebem `AuthService` tipado como **abstração**, não como `FirebaseAuth` direto.
2. **Dados** (`data/`) implementa persistência e APIs — `UserRepositoryImpl`, `UserRemoteDataSourceImpl`, mappers.
3. **Infra compartilhada** (`lib/core/services/`) concentra integrações (Firebase Auth, Functions, cache, liveness mock, ML Kit). Onde há troca futura (HTTP real vs mock), existe **interface + implementação**.
4. **Composição** — `GetIt` registra singletons de infra; **use cases e repositório de usuário** são montados no `main.dart` e passados às fábricas dos BLoCs. Assim a UI não escolhe implementação: ela só recebe `AuthBloc` / `UsersBloc` já configurados.

## Mapa abstração → implementação atual

| Abstração | Onde está | Implementação registrada / instanciada |
|-----------|-----------|----------------------------------------|
| `UserRepository` | `features/users/domain/repositories/` | `UserRepositoryImpl` (`main.dart`) |
| `UserRemoteDataSource` | `features/users/data/datasources/` | `UserRemoteDataSourceImpl(FirebaseFirestore)` |
| `UserLocalDataSource` | `features/users/data/datasources/` | `UserLocalDataSourceImpl(ILocalCacheService)` |
| `AuthService` | `core/services/auth_services.dart` | `FirebaseAuthService` → `GetIt` em `setup_locator.dart` |
| `AuthFunctionsService` | `core/services/auth_functions.dart` | `FirebaseAuthFunctionsService` → `GetIt` |
| `ILocalCacheService` | `core/services/auto_cache_services.dart` | `AutoCacheServiceImplementation` → `GetIt` |
| `IBiometricAuthService` | `core/services/biometrics_services.dart` | `BiometricAuthServiceImpl` → `GetIt` |
| `LivenessApiService` | `core/services/liveness_api_service.dart` | `LivenessApiMockService` → `GetIt` (trocar por cliente HTTP real quando existir backend) |
| `FaceFramingDetector` | `core/services/face_framing_detector.dart` | `MlKitFaceFramingDetector` → `GetIt.registerFactory` (nova instância por fluxo de câmera) |
| `AppNotificationsController` | `core/presentation/notifications/` | implementação concreta → `GetIt` |

**Sem interface dedicada no Dart (acoplamento direto à lib):** `InternetConnectionChecker` e `ConnectionBloc` em `connectivity_services.dart` — o Cubit usa o pacote diretamente; se no futuro precisar trocar estratégia de rede, extraia um contrato semelhante aos demais.

## Onde olhar no código

- Registros globais: `lib/core/config/setup_locator.dart`
- Montagem do repositório/usuário e use cases: `lib/main.dart`
- Injeção nos BLoCs: `lib/core/config/bloc_factories.dart`

## Leitura complementar

- [Serviços em `core`](../core-services.md) — papel de cada serviço e dependências.
- [Convenções](../conventions.md) — pastas por feature e uso de `GetIt`.
