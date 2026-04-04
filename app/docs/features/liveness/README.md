# Feature `liveness`

**Sessão de prova de vida** (início de sessão + análise da captura) e **enquadramento facial** na câmera. Depende de **`LivenessApiService`** em `core` (hoje **mock**); o envio bem-sucedido avança o onboarding via **`SendLivenessUseCase`** na feature `authentication`.

## Dados

### `LivenessDto` (`data/dtos/liveness_dto.dart`)

Payload para análise: `userId`, `provider` (ex.: `mock`), `providerSessionId`, caminhos locais opcionais de imagem (`frontImageLocalPath`, `selfieSubmissionLocalPath`), `capturedAt`, `metadata` livre para o SDK sem acoplar o domínio ao plugin.

## Domínio — use cases

| Use case | Responsabilidade | Dependências |
|----------|------------------|--------------|
| `InitLivenessSessionUseCase` | Chama `LivenessApiService.initLivenessSession(userId)`; valida id não vazio. | `LivenessApiService` |
| `LivenessAnalysisUseCase` | Chama `LivenessApiService.analyzeLiveness(capture)`. | `LivenessApiService` |

Ambos retornam **`Either<Failure, …>`** via `ErrorHandler` em exceções.

## Apresentação

- **`FaceFramingCubit`** (`presentation/cubit/face_framing_cubit.dart`) — consome **`FaceFramingDetector`** (factory no `GetIt`) para orientar o usuário no preview da câmera antes da captura.

A tela de captura “pesada” e verificação ficam em **`authentication/presentation/pages/`** (`selfie_liveness_page`, `selfie_verification_page`), mas a lógica de **API de liveness** e DTOs estão aqui.

## Orquestração com onboarding

- **`SendLivenessUseCase`** (em `authentication`) chama **`LivenessAnalysisUseCase`** e, se `passed`, **`UpdateUserOnboardingStepUseCase`** com `OnboardingStep.permissions`.

## Troca mock → API real

1. Implementar `LivenessApiService` com HTTP/SDK real.
2. Registrar no `setup_locator.dart` no lugar de `LivenessApiMockService`.
3. Manter `LivenessDto` alinhado ao contrato do backend.

## Referências

- [core-services](../../core-services.md) — `LivenessApiService`, `FaceFramingDetector`.
- [Inversão de dependência](../../architecture/inversao-de-dependencia.md).
- [authentication](../authentication/README.md) — `SendLivenessUseCase` e telas.
