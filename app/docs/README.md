# Documentação do app (Parceleo)

Material de apoio ao [README principal](../README.md). Aqui entram guias de **setup**, **build**, **decisões técnicas** e **documentação por feature**.

## Índice geral

| Documento | Conteúdo |
|-----------|----------|
| [architecture/inversao-de-dependencia.md](architecture/inversao-de-dependencia.md) | Abstrações vs implementações, `GetIt`, composição no `main` — **inversão de dependência** |
| [core-services.md](core-services.md) | Serviços em `lib/core/services/` (auth, functions, cache, biometria, liveness, ML Kit, rede) |
| [ios-build.md](ios-build.md) | Xcode, CocoaPods, deployment target, `Runner.xcworkspace`, erros comuns (Firebase / Flutter module), APNs e Phone Auth |
| [ui-notifications.md](ui-notifications.md) | Banners no topo (`showAppError` / `showAppWarning`), arquivos e uso |
| [codegen.md](codegen.md) | `build_runner`, rotas (`auto_route`), mappers (`dart_mappable`) |
| [firebase-app-check.md](firebase-app-check.md) | App Check: providers, debug tokens, Console |
| [conventions.md](conventions.md) | Onde colocar código novo, BLoC, use cases, `GetIt` |

## Documentação por feature (`docs/features/`)

| Pasta | Escopo |
|-------|--------|
| [features/authentication](features/authentication/README.md) | CPF, cadastro, SMS/OTP, `AuthBloc`, DTOs; ligação com users / permissions / liveness |
| [features/users](features/users/README.md) | `UserEntity`, repositório, data sources, use cases de perfil |
| [features/permissions](features/permissions/README.md) | DTOs e entidades de permissão, use cases de sistema (câmera/biometria + stubs) |
| [features/liveness](features/liveness/README.md) | `LivenessDto`, sessão e análise, `FaceFramingCubit` |

O fluxo funcional de telas e `OnboardingStep` continua resumido no **README** da raiz do app.
