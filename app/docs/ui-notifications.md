# Notificações na UI (banners no topo)

Sistema **in-app** que substitui o antigo `ScaffoldMessenger` global: mensagens aparecem **no topo da tela**, abaixo da status bar, com cores por severidade.

## API

```dart
import 'package:app/core/presentation/notifications/app_notifications.dart';

showAppError('Falha de rede ou servidor.');
showAppWarning('Preencha todos os campos.');
```

- **Erro** — fundo vermelho (`AppPalette.textError`).  
- **Aviso** — fundo laranja (validações, feedbacks leves).

## Comportamento

- Auto-dismiss após ~**4 segundos** (configurável no controller).  
- Toque no banner **fecha** na hora.  
- Implementação: `AppNotificationsController` (`GetIt`) + `AppNotificationsHost` no `builder` do `MaterialApp.router` em `main.dart`.

## Arquivos

| Arquivo | Papel |
|---------|--------|
| `lib/core/presentation/notifications/app_notifications_controller.dart` | Estado + `showError` / `showWarning` / `dismiss` |
| `lib/core/presentation/notifications/app_notifications_host.dart` | Layout e animação do banner |
| `lib/core/presentation/notifications/app_notifications.dart` | Funções globais + exports |
| `lib/core/config/setup_locator.dart` | Registro do singleton |

Não confundir com **push notifications** do sistema (permissão de notificação no onboarding).
