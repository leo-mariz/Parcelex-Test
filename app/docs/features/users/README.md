# Feature `users`

Modelo de **conta** (`UserEntity`), **acesso a dados** (Firestore + cache local) e **casos de uso** usados no onboarding e na home. É a feature com **repositório e data sources** completos; `authentication` consome estes use cases para criar/atualizar perfil.

## Entidade de domínio

### `UserEntity` (`domain/entities/user_entity.dart`)

Representa o documento de usuário (espelho lógico do Firestore + cache).

| Campo | Notas |
|-------|--------|
| `id` | UID do Firebase Auth; obrigatório para create/update remotos. |
| `email`, `phoneNumber`, `fullName` | Dados de perfil. |
| `onboardingStep` | `OnboardingStep` — fonte da verdade para navegação pós-login (ver README do app). |
| `permissionPrompts` | `PermissionPromptStateEntity` — histórico de interação nas telas de permissão. |
| `createdAt`, `updatedAt` | Metadados. |
| `cpf` | Opcional no cliente; fingerprint pode existir só no servidor. |

Serialização: **dart_mappable** (`user_entity.mapper.dart`).

### Extensões

- `domain/extensions/user_entity_reference.dart` — coleção Firestore e chaves de cache.

## Repositório (contrato vs implementação)

| Camada | Arquivo | Papel |
|--------|---------|--------|
| Contrato | `domain/repositories/user_repository.dart` | `create`, `getById`, `getAll`, `update`, `delete` retornando `Either<Failure, …>`. |
| Implementação | `data/repositories/user_repository_impl.dart` | Orquestra **cache primeiro** em `getById` / `getAll`; escrita remota + sincronização local. |

Inversão de dependência: use cases dependem apenas de **`UserRepository`**.

## Data sources

| Contrato | Implementação | Backend |
|----------|---------------|---------|
| `UserRemoteDataSource` | `UserRemoteDataSourceImpl` | Firestore (mapeamento com utilitários em `core/utils/firestore_mappable_utils.dart`). |
| `UserLocalDataSource` | `UserLocalDataSourceImpl` | `ILocalCacheService` (flutter_auto_cache), chaves derivadas de `UserEntityReference`. |

Erros de Firebase são normalizados para exceções de domínio (`CloudFirebaseException`, etc.) no remote data source.

## Use cases (`domain/usecases/`)

| Use case | Responsabilidade |
|----------|------------------|
| `GetUserUseCase` | Busca usuário por id (repo já aplica cache → remoto). |
| `CreateUserUseCase` | Cria documento + cache. |
| `UpdateUserUseCase` | Atualiza documento + cache. |
| `UpdateUserOnboardingStepUseCase` | Lê usuário atual, atualiza só `onboardingStep` (+ `updatedAt`). |
| `UpdateUserPermissionsUseCase` | Mescla `PermissionsDto` em `permissionPrompts` e define `onboardingStep: done`. Usado também pelo fluxo com `AuthLoadingPage` + `UsersBloc`. |
| `DeleteUserUseCase` | Remove usuário (quando usado). |

## Apresentação

- **`UsersBloc`** — no fluxo atual, principalmente `UpdateUserPermissionsSubmitted` → `UpdateUserPermissionsUseCase`.
- Eventos/estados em `presentation/bloc/events|states/`.

## Referências

- [Inversão de dependência](../../architecture/inversao-de-dependencia.md) — tabela `UserRepository` / data sources.
- [Serviços core](../../core-services.md) — `ILocalCacheService`.
- [authentication](../authentication/README.md) — quem chama create/update durante OTP e cadastro.
