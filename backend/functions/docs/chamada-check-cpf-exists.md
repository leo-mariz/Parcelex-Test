# Como chamar a Cloud Function `checkCpfExists`

Callable HTTPS (Firebase Functions **Gen 2**) que consulta se um CPF já está cadastrado e, em caso positivo, devolve o número de celular associado ao documento do usuário no Firestore.

| Item | Valor |
|------|--------|
| **Nome da function** | `checkCpfExists` |
| **Região** | `southamerica-east1` |
| **Tipo** | HTTPS Callable (`onCall`) |

---

## Contrato

### Entrada (`data`)

Objeto com um único campo obrigatório:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `cpf` | `string` | CPF com ou sem máscara; apenas os dígitos são usados na busca. |

Se `cpf` estiver ausente, não for string ou for só espaços, a function responde com erro **`invalid-argument`**.

### Saída (sucesso)

Objeto JSON:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `exists` | `boolean` | `true` se existir usuário com esse CPF (após normalizar dígitos). |
| `phoneNumber` | `string \| null` | Telefone do documento quando `exists === true`; `null` se não houver usuário ou se o campo não existir no Firestore. |

---

## Flutter (recomendado)

1. Confirme que o app usa o mesmo projeto Firebase que as Functions.
2. Use a **mesma região** da function (`southamerica-east1`).

```dart
import 'package:cloud_functions/cloud_functions.dart';

Future<Map<String, dynamic>> checkCpfExists(String cpf) async {
  final functions = FirebaseFunctions.instanceFor(
    region: 'southamerica-east1',
  );
  final callable = functions.httpsCallable('checkCpfExists');
  final result = await callable.call(<String, dynamic>{'cpf': cpf});
  final data = Map<String, dynamic>.from(result.data as Map);
  return data;
}

// Exemplo de uso:
// final out = await checkCpfExists('123.456.789-00');
// final exists = out['exists'] as bool;
// final phone = out['phoneNumber'] as String?;
```

**Dependência:** pacote `cloud_functions` no `pubspec.yaml`, já alinhado à versão do BoM do Firebase para Flutter.

---

## Web / Node (JavaScript ou TypeScript)

```javascript
import { getFunctions, httpsCallable } from 'firebase/functions';

const functions = getFunctions(undefined, 'southamerica-east1');
const checkCpfExists = httpsCallable(functions, 'checkCpfExists');

const result = await checkCpfExists({ cpf: '12345678900' });
console.log(result.data);
// { exists: true, phoneNumber: '+5511999999999' } ou similar
```

---

## Erros comuns

| Situação | O que acontece |
|----------|----------------|
| `cpf` inválido / vazio | `FirebaseFunctionsException` com código `invalid-argument`. |
| Function não deployada ou nome errado | `not-found` ou falha de rede. |
| Região diferente da deployada | Erro de chamada ou timeout; use sempre `southamerica-east1` se for a região configurada no código. |

---

## Deploy

Na pasta `backend/functions`:

```bash
npm run build
firebase deploy --only functions:checkCpfExists
```

(ou `firebase deploy --only functions` para subir todas.)

---

## Obrigatório (Gen 2): evitar 403 “request was not authenticated”

Callables da **2ª geração** rodam como serviço no **Cloud Run**. Por padrão o endpoint pode exigir identidade GCP; o app chama **sem** usuário Firebase logado, então o Cloud Run responde **403** com mensagem do tipo:

> The request was not authenticated. Either allow unauthenticated invocations or set the proper Authorization header.

No SDK atual, a opção `invoker: "public"` em `onCall` **pode não ser aplicada** ao deploy (ela é aplicada de forma confiável em `onRequest`). É preciso liberar o invoker **uma vez** no Google Cloud.

### Opção A — Console

1. [Cloud Run](https://console.cloud.google.com/run) → projeto **parceleo-fd28b** (ou o seu).
2. Abra o serviço **`checkcpfexists`** (nome em minúsculas no Cloud Run).
3. Aba **Segurança** / **Permissões** → permitir invocações não autenticadas (**Allow unauthenticated invocations**), ou adicione o principal `allUsers` com papel **Cloud Run Invoker** (`roles/run.invoker`).

### Opção B — gcloud

Substitua `PROJECT_ID` e `REGION` se forem diferentes:

```bash
gcloud run services add-iam-policy-binding checkcpfexists \
  --region=southamerica-east1 \
  --member=allUsers \
  --role=roles/run.invoker \
  --project=parceleo-fd28b
```

Depois disso, o **mesmo** URL `https://southamerica-east1-…cloudfunctions.net/checkCpfExists` passa a aceitar a chamada feita pelo SDK do Firebase a partir do app.

---

## Observações de segurança

- A function **não exige** usuário autenticado no Firebase Auth por padrão (adequado para checagem antes do login). Se no futuro quiser restringir (por exemplo, só usuários logados ou App Check), isso deve ser configurado explicitamente no código e no console.

- O use case atual percorre **todos** os usuários do Firestore para localizar o CPF; para muitos documentos, considere índice/campo de busca dedicado em uma evolução futura.
