# Feature `authentication`

Fluxo de **entrada por CPF**, **cadastro**, **SMS / OTP**, telas de **onboarding visual** (selfie, liveness, permissões) e **`AuthBloc`**. Parte da lógica persiste perfil via feature **`users`**; permissões de sistema reutilizam use cases da feature **`permissions`**; liveness chama use cases da feature **`liveness`**.

> **Organização física:** várias páginas de permissão estão em `lib/features/authentication/presentation/pages/` por serem passos do mesmo roteiro de onboarding, embora o domínio de permissões viva em `features/permissions/`.

## Camadas

### `presentation/`

| Peça | Função |
|------|--------|
| `pages/` | Telas: boas-vindas + CPF, cadastro, loading hub, SMS, selfie, liveness, verificação, permissões (notificação, biometria, local), home placeholder (importada de `home` nas rotas). |
| `bloc/` | `AuthBloc` — um conjunto de eventos/estados por caso de uso (loading/success/error + reset). |
| `navigation/otp_post_login_route.dart` | Decide a próxima rota após OTP com base em `UserEntity.onboardingStep`. |
| `widgets/` | Componentes reutilizados nas telas de auth (hero, logo, scaffold de passo, etc.). |

### `domain/usecases/`

| Use case | Responsabilidade | Dependências principais |
|----------|------------------|-------------------------|
| `VerifyCpfUseCase` | Valida dígitos do CPF e chama Cloud Function `checkCpfExists`. | `AuthFunctionsService` |
| `RegisterOnboardingUseCase` | Envia SMS de cadastro; se login automático, cria perfil; retorna DTO com dados de SMS / onboarding pendente. | `SendLoginSmsUseCase`, `CreateUserUseCase` |
| `SendLoginSmsUseCase` | Dispara SMS de login (E.164, reenvio com token). | `AuthService` |
| `VerifySmsOtpUseCase` | Confirma OTP; se houver `pendingOnboarding`, cria usuário; senão carrega perfil. | `AuthService`, `GetUserUseCase`, `CreateUserUseCase` |
| `GetUserUidUseCase` | Obtém UID do usuário autenticado (para liveness). | `AuthService` |
| `SendLivenessUseCase` | Orquestra análise de liveness e, se aprovada, define onboarding para `permissions`. | `LivenessAnalysisUseCase`, `UpdateUserOnboardingStepUseCase` |
| `SavePermissionsPreferencesUseCase` | Delega a `UpdateUserPermissionsUseCase` (mesma regra; mantido no `AuthBloc` por compatibilidade). | `UpdateUserPermissionsUseCase` |
| `LogoutUseCase` | Encerra sessão Firebase e limpa cache local relevante. | `AuthService`, `ILocalCacheService` |

Os use cases de **câmera / biometria / notificação / localização** estão na feature `permissions` mas são disparados pelo `AuthBloc` (ver doc dessa feature).

### `data/`

| Artefato | Função |
|----------|--------|
| `dtos/login_dto.dart` | CPF (dígitos) para verificação. |
| `dtos/onboarding_dto.dart` | Payload do formulário de cadastro + flags legais. |
| `dtos/verify_sms_otp_dto.dart` | `verificationId`, código SMS, `pendingOnboarding` opcional. |
| `dtos/verify_sms_otp_response_dto.dart` | UID + `UserEntity?` após OTP. |
| `dtos/send_login_sms_response_dto.dart` | Dados do envio de SMS (ids, token de reenvio). |
| `dtos/register_onboarding_response_dto.dart` | Resposta do registro (SMS + onboarding). |
| `mappers/onboarding_user_mapper.dart` | Monta `UserEntity` a partir de DTOs de onboarding. |

**Não há** `repository` próprio desta feature: perfil de usuário é sempre `UserRepository` na feature `users`.

## Referências cruzadas

- Fluxo de telas (resumo): [README principal](../../README.md).
- Inversão de dependência: [inversao-de-dependencia.md](../../architecture/inversao-de-dependencia.md).
- Usuário e Firestore: [users/README.md](../users/README.md).
- Permissões de sistema: [permissions/README.md](../permissions/README.md).
- Sessão e análise de liveness: [liveness/README.md](../liveness/README.md).
