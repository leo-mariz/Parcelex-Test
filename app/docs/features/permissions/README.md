# Feature `permissions`

Regras para **permissões de sistema** (câmera, biometria, notificações, localização) e o **modelo persistido** no perfil (`PermissionPromptStateEntity`). Os **DTOs de decisão de UI** alimentam o `UpdateUserPermissionsUseCase` na feature `users`.

> As **telas** de onboarding de permissão ficam em `features/authentication/presentation/pages/`; esta feature concentra **domínio + DTOs** e é importada por `users` e `authentication`.

## Dados

### `PermissionsDto` (`data/dtos/permissions_dto.dart`)

Agrega o resultado da jornada do usuário em três eixos:

- `notification`, `biometric`, `location` — cada um é `PermissionPromptResult`:
  - `granted`, `skipped`, `denied`, `permanentlyDenied`

Montado na **`LocationPermissionPage`** e enviado via `AuthLoadingRoute(awaitingUserPermissionsUpdate: true)` para o **`UsersBloc`**.

## Domínio

### Entidades (`domain/entities/`)

- **`PermissionPromptRecordEntity`** — `seen`, `skipped`, `completedAt` para uma permissão.
- **`PermissionPromptStateEntity`** — agrega `notification`, `location`, `biometric`.

Usadas dentro de **`UserEntity.permissionPrompts`** e preenchidas por `permissionStateFromDto` (abaixo).

### `permissions_from_dto.dart`

Função **`permissionStateFromDto(PermissionsDto)`** — traduz cada `PermissionPromptResult` em `PermissionPromptRecordEntity` (com timestamp de conclusão). Não é classe de use case, mas é a ponte entre UI e entidade persistida.

### Use cases (`domain/usecases/`)

| Use case | Responsabilidade | Dependências |
|----------|------------------|--------------|
| `EnableCameraPermissionUseCase` | Solicita câmera (`requestCameraPermission` em `core/permissions/camera_permission.dart`); mapeia `PermissionStatus` para `Either<Failure, Unit>`. | — |
| `EnableBiometricsUseCase` | Garante biometria disponível, autentica e chama `enableBiometricsWithoutStoredCredentials`. | `IBiometricAuthService` |
| `EnableNotificationsUseCase` | **Stub** — retorna falha genérica até integrar com `permission_handler` / APIs (há TODO no código). As telas de onboarding podem usar `core/permissions/notification_permission.dart` diretamente. | — |
| `EnableLocalizationUseCase` | **Stub** — mesmo padrão; a tela de localização usa `requestLocationWhenInUsePermission` em `core/permissions/location_permission.dart` na prática. | — |

Os implementados retornam **`Either<Failure, Unit>`** para o **`AuthBloc`**. Quando os stubs forem preenchidos, alinhar com os helpers já usados nas páginas.

## Fluxo resumido (UI → persistência)

1. Telas pedem OS prompts e produzem `PermissionPromptResult` por etapa.
2. Última tela monta **`PermissionsDto`** e abre loading que dispara **`UpdateUserPermissionsSubmitted`** (`UsersBloc`).
3. **`UpdateUserPermissionsUseCase`** aplica `permissionStateFromDto`, atualiza `UserEntity` e grava `onboardingStep: done`.

## Referências

- [users](../users/README.md) — `UpdateUserPermissionsUseCase`, `UserEntity.permissionPrompts`.
- [core-services](../../core-services.md) — `IBiometricAuthService`.
- [authentication](../authentication/README.md) — onde o `AuthBloc` encaixa os use cases de permissão.
