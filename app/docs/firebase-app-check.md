# Firebase App Check

Protege backends Firebase contra abuso; no **Phone Auth** no iOS pode ajudar na confiança do app, mas **não substitui** o fluxo APNs para evitar Safari/reCAPTCHA.

## Código

- Ativação: `lib/core/config/setup_app_check.dart`, chamada após `Firebase.initializeApp` em `main.dart`.
- **Debug** — providers de debug (registrar tokens no Console).  
- **Release / profile** — Play Integrity (Android) e **App Attest** (iOS), conforme `setup_app_check.dart` (exige capability correta no Xcode quando aplicável).

## Console Firebase

1. **App Check** → registrar o app iOS/Android com o provedor adequado.  
2. Por produto (**Authentication**, **Firestore**, **Functions**, etc.): começar em modo **Monitor** e só depois **Enforcement**.  
3. Em **debug**, copiar o token exibido no log (Android/iOS) e cadastrar em **App Check → Gerenciar tokens de debug**.

Sem token de debug, com enforcement ligado, builds de debug podem falhar nas chamadas.
