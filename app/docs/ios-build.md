# iOS — build e Xcode

## Abrir o projeto certo

- Use **`ios/Runner.xcworkspace`** no Xcode (CocoaPods).  
- **Não** abra só o `Runner.xcodeproj` — isso costuma gerar **No such module 'Flutter'** ou dependências quebradas.

## Deployment target

O app e os pods estão alinhados em **iOS 15.5** (ver `ios/Podfile` e `IPHONEOS_DEPLOYMENT_TARGET` no `Runner.xcodeproj`).  
Se o Xcode mostrar erro do tipo *“Compiling for iOS X, but module 'FirebaseAuth' has a minimum deployment target…”*, o target do **Runner** ficou menor que o dos pods — volte a **15.5** em todas as configurações (Debug / Release / Profile).

`ios/Flutter/AppFrameworkInfo.plist` (`MinimumOSVersion`) deve refletir o mesmo valor.

## CocoaPods

Na pasta `app/ios/`:

```bash
pod install
```

Se o CocoaPods falhar com **Unicode / ASCII-8BIT** (comum em caminhos com espaço ou encoding do terminal), tente:

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
pod install
```

Fluxo recomendado após mudar dependências Flutter nativas:

```bash
cd app
flutter pub get
cd ios && pod install
```

## Firebase Auth — Phone / APNs

O `AppDelegate` registra notificações remotas e repassa o token APNs ao Firebase Auth para **reduzir** o fallback que abre Safari/reCAPTCHA. Ainda assim é preciso:

- Chave **APNs** (.p8) configurada no Firebase Console  
- Capability **Push Notifications** no App ID / Xcode  
- Testar em **dispositivo físico** quando possível (simulador costuma piorar o fluxo silencioso)

## `No such module 'Flutter'` no `AppDelegate.swift`

Causas frequentes:

1. Abriu **`Runner.xcodeproj`** em vez de **`Runner.xcworkspace`**.  
2. **`pod install`** não foi executado depois de mudar o `Podfile` ou dependências.  
3. **`use_frameworks!` dinâmico** com vários pods Swift (ex.: Firebase) às vezes quebra o módulo `Flutter` no Xcode — o projeto usa **`use_frameworks! :linkage => :static`** no `Podfile` por isso.

Depois de alterar o `Podfile`:

```bash
cd app/ios
rm -rf Pods Podfile.lock .symlinks
pod install
```

Abra de novo o **`Runner.xcworkspace`**, **Clean Build Folder** e compile.

## Limpeza quando o build “gruda”

```bash
cd app
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
```

Depois **Product → Clean Build Folder** no Xcode e compile de novo.
