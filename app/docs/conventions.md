# Convenções de código

## Estrutura por feature

Em `lib/features/<nome>/`:

- **`presentation/`** — páginas, BLoCs/Cubits, widgets específicos da feature.  
- **`domain/`** — entidades, use cases, falhas tratadas com `Either` (`fpdart`).  
- **`data/`** — DTOs, mappers, datasources, implementações de repositório.

Compartilhado fica em **`lib/core/`** (tema, design system, roteador, serviços, `setup_locator`, notificações).

## Estado global

- **`AuthBloc`** — autenticação e onboarding (CPF, SMS, OTP, liveness, permissões de sistema, logout, etc.).  
- **`UsersBloc`** — atualizações de perfil no fluxo atual (ex.: permissões persistidas).  
- Fábrica dos blocs: `lib/core/config/bloc_factories.dart` (use cases montados no `main.dart`).

## Injeção (`GetIt`)

Serviços singleton e factories em `setup_locator.dart`. Use cases “de tela” costumam ser criados no `main` e passados ao `createAuthBloc` / `createUsersBloc`, não registrados no `GetIt`, salvo decisão explícita do time.

Abstrações (interfaces) vs implementações atuais: [architecture/inversao-de-dependencia.md](architecture/inversao-de-dependencia.md). Serviços em `core`: [core-services.md](core-services.md).

## Novo fluxo que cruza features

1. Definir **use case(s)** no domínio adequado (ou `core` se for infra genérica).  
2. Expor **eventos/estados** no BLoC responsável (evitar duplicar a mesma regra na UI).  
3. Registrar dependências na fábrica + `main` se precisar de novos use cases no `AuthBloc`/`UsersBloc`.

## Liveness + onboarding

O envio pós-captura usa **`SendLivenessUseCase`**, que orquestra análise + atualização do passo de onboarding (`OnboardingStep.permissions`), para não espalhar essa regra nas telas.
