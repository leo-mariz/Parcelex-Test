# Parcelex — app Flutter

Cliente mobile do **Parcelex** (título exibido no app: **Parceleo**). O fluxo atual concentra-se em **autenticação por CPF**, **SMS (OTP)**, **cadastro / onboarding**, **prova de vida (selfie / liveness)** e **telas de permissões** (notificação, biometria, localização), com estado de onboarding persistido no **Firestore** (`OnboardingStep`).

## Pré-requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) compatível com o SDK do projeto (`pubspec.yaml`: `^3.10.3`).
- Ambiente **Firebase** configurado (o app usa `lib/firebase_options.dart` via FlutterFire).
- **iOS**: CocoaPods (`pod install` em `ios/` após mudanças de dependências nativas).
- **Firebase App Check**: em **debug**, é necessário registrar tokens de debug no [Console do Firebase](https://console.firebase.google.com/); em release/profile o app usa Play Integrity (Android) e App Attest (Apple). Ver `lib/core/config/setup_app_check.dart`.

## Como rodar

Na pasta `app/`:

```bash
flutter pub get
flutter run
```

Se as rotas geradas (`lib/core/config/app_router.gr.dart`) ou os mappers (`*.mapper.dart`) estiverem desatualizados após alterações:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Stack principal

| Área | Pacotes / padrão |
|------|-------------------|
| Rotas | [auto_route](https://pub.dev/packages/auto_route) (`AppRouter`, rotas em `lib/core/config/app_router.dart`) |
| Estado (auth / permissões) | [flutter_bloc](https://pub.dev/packages/flutter_bloc) — `AuthBloc`, `UsersBloc` |
| Injeção | [get_it](https://pub.dev/packages/get_it) — `setup_locator.dart` |
| Auth / dados | Firebase Auth, Cloud Firestore, Cloud Functions |
| Erros / fluxo | [fpdart](https://pub.dev/packages/fpdart) (`Either`) nos use cases |
| Modelos | [dart_mappable](https://pub.dev/packages/dart_mappable) |
| OTP | `sms_autofill`, teclado numérico custom na tela de SMS |
| Liveness / câmera | Sessão via use cases + fluxo de telas selfie; ML Kit Face Detection nas dependências |

## Arquitetura (visão rápida)

Organização por **feature** sob `lib/features/` (`authentication`, `users`, `permissions`, `liveness`, …) e **`lib/core/`** para roteamento, tema, design system, serviços compartilhados e configuração.

- **Apresentação**: páginas (`presentation/pages`), BLoCs, widgets da feature.
- **Domínio**: entidades, contratos de repositório, **use cases** (uma responsabilidade por caso).
- **Dados**: implementações de repositório, data sources (ex.: Firestore, cache local via `flutter_auto_cache`).

O `main.dart` inicializa Firebase, App Check, cache, `GetIt`, monta repositório/uso de usuário e expõe `AuthBloc` + `UsersBloc` no topo da árvore.

## Fluxo: login e onboarding

A rota inicial é **`LoginWelcomeRoute`** (tela “Entre ou cadastre-se” com CPF). O widget **`AuthLoadingPage`** é reutilizado como **hub de carregamento** com comportamentos distintos conforme os argumentos da rota (ver docstring em `auth_loading_page.dart`).

### 1. Entrada com CPF

1. Usuário informa o CPF em **`LoginWelcomePage`** → dispara `VerifyCpfSubmitted` no **`AuthBloc`** e abre **`AuthLoadingRoute(cpfMasked: …)`**.
2. Em **`AuthLoadingPage`** (modo login padrão):
   - **`VerifyCpfSuccess` com `exists: false`** → navega para **`CreateAccountRoute`** (cadastro).
   - **`VerifyCpfSuccess` com `exists: true`** e telefone cadastrado → dispara `SendLoginSmsSubmitted` e, em sucesso, **`SmsConfirmationRoute`** (login).
   - CPF sem telefone cadastrado → mensagem de erro e volta.
   - Falhas de CPF ou envio de SMS → snack de erro e volta.

### 2. Cadastro complementar (novo usuário)

**`CreateAccountPage`**: nome, e-mail, celular, CEP, pergunta trabalhador assinado, consentimentos → `RegisterOnboardingSubmitted` + **`AuthLoadingRoute(isRegisterOnboarding: true)`**.

- Sucesso → **`SmsConfirmationRoute`** com dados de SMS e, se aplicável, `pendingOnboarding` para concluir o perfil após o OTP.
- Em alguns cenários o telefone já vem verificado pelo Firebase (`alreadyPhoneVerified`); a tela oferece continuar sem digitar OTP e segue para selfie quando cabível.

### 3. Confirmação por SMS (OTP)

**`SmsConfirmationPage`**:

- Envia `VerifySmsOtpSubmitted` com `VerifySmsOtpDto` (inclui `pendingOnboarding` no fluxo de cadastro).
- Reenvio de SMS: `SendLoginSmsSubmitted` com `forceResendingToken` quando houver.
- Após **`VerifySmsOtpSuccess`**, a navegação é centralizada em **`routeAfterOtpSuccess`** (`lib/features/authentication/presentation/navigation/otp_post_login_route.dart`), usando **`UserEntity.onboardingStep`** retornado/atualizado no perfil:

| `OnboardingStep` (Firestore) | Próxima tela (resumo) |
|-----------------------------|------------------------|
| `null`, `none`, `liveness` | Selfie / prova de vida (`SelfieSubmissionRoute`) |
| `permissions` | `NotificationPermissionRoute` |
| `done` | `HomePlaceholderRoute` |
| `profileComplete` (demais casos do `switch`) | `HomePlaceholderRoute` |

> Ajustes futuros no enum ou na regra de negócio devem manter este arquivo e esta tabela alinhados.

### 4. Selfie e liveness

1. **`SelfieSubmissionPage`** → pede permissão de câmera (`EnableCameraPermissionRequested`). Se OK → **`AuthLoadingRoute(awaitingLivenessInit: true)`** + `InitLivenessSessionRequested` → em sucesso **`SelfieLivenessRoute`** com IDs de sessão.
2. **`SelfieLivenessPage`** → **`SelfieVerificationRoute`**.
3. **`SelfieVerificationPage`** aguarda resultado de **`SendLivenessRequested`** / `SendLivenessSuccess` ou erro; em sucesso navega para **`NotificationPermissionRoute`**.

### 5. Permissões (notificação → biometria → localização)

Ordem efetiva:

1. **`NotificationPermissionPage`** → **`BiometricPermissionRoute`** (com resultado do prompt de notificação).
2. **`BiometricPermissionPage`** → **`LocationPermissionRoute`** (acumula resultados).
3. **`LocationPermissionPage`** monta **`PermissionsDto`** e abre **`AuthLoadingRoute(awaitingUserPermissionsUpdate: true, permissionsDto: …)`**, que dispara **`UpdateUserPermissionsSubmitted`** no **`UsersBloc`**.
4. Sucesso → **`HomePlaceholderRoute`**; erro → mensagem e retorno à primeira tela do bloco de permissões.

**`HomePlaceholderPage`** é a home provisória pós-onboarding.

## Estado global relevante

### `AuthBloc`

Agrupa fluxos por **caso de uso** (padrão: `Loading` / `Success` / `Error` + `Reset` por fluxo). Eventos incluem, entre outros:

- CPF: `VerifyCpfSubmitted`
- Cadastro: `RegisterOnboardingSubmitted`
- SMS login: `SendLoginSmsSubmitted`
- OTP: `VerifySmsOtpSubmitted`
- Liveness: `InitLivenessSessionRequested`, `SendLivenessRequested`
- Permissões de sistema: `EnableCameraPermissionRequested`, `EnableBiometricsRequested`, `EnableNotificationsRequested`, `EnableLocalizationRequested`
- Consolidação de preferências de permissões no perfil: `SavePermissionsPreferencesSubmitted`
- `LogoutRequested`

Arquivos de referência: `lib/features/authentication/presentation/bloc/`.

### `UsersBloc`

Focado em atualizações de perfil necessárias ao fluxo atual, em especial **`UpdateUserPermissionsSubmitted`** → `UpdateUserPermissionsUseCase`.

## Mais documentação

Guias complementares (build iOS, banners de UI, App Check, codegen, convenções) e o **índice por feature** estão em **[`docs/`](docs/README.md)**.

Destaques:

- **[Inversão de dependência](docs/architecture/inversao-de-dependencia.md)** — contratos (`UserRepository`, `AuthService`, etc.) e implementações atuais.
- **[Serviços `core`](docs/core-services.md)** — papel de cada serviço compartilhado.
- **`docs/features/`** — `authentication`, `users`, `permissions`, `liveness` (entidades, use cases, repositórios, data sources).

## Assets e ícone

- Imagens em `assets/images/`.
- Ícone do launcher configurado em `pubspec.yaml` (`flutter_launcher_icons`).

---

Para o repositório completo (app + Cloud Functions), veja o `README.md` na raiz do monorepo.
