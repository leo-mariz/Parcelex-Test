# Geração de código (`build_runner`)

## Quando rodar

Execute após alterar:

- Rotas anotadas com `@RoutePage` / `AppRouter` → **`app_router.gr.dart`**
- Modelos com `dart_mappable` → **`*.mapper.dart`**

Na pasta `app/`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Para desenvolvimento com rebuild ao salvar (opcional):

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Pacotes envolvidos

- **auto_route** — `lib/core/config/app_router.dart` gera `app_router.gr.dart`.  
- **dart_mappable** — enums e entidades com `part '...mapper.dart';` e `build.yaml` quando aplicável.

Se o CI ou outro dev reclamar de arquivos gerados faltando, commite os `*.gr.dart` / `*.mapper.dart` conforme a política do time (este repositório costuma versioná-los).
