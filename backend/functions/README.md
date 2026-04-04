# Firebase Cloud Functions (Parcelex)

Backend em **TypeScript** para o app Parcelex. Hoje expõe uma **HTTPS Callable** usada na tela inicial (verificação de CPF antes do login).

- **Runtime:** Node.js **24** (`package.json` → `engines`)
- **Firebase:** Functions **v2** (`firebase-functions` v7), Admin SDK
- **Build:** `tsc` compila `src/` → `lib/` (ponto de entrada: `lib/index.js`)

## Pré-requisitos

- [Node.js 24](https://nodejs.org/) (ou a versão indicada em `engines`)
- [Firebase CLI](https://firebase.google.com/docs/cli) logado no projeto correto
- Projeto Firebase com Firestore (mesmo usado pelo app Flutter)

## Scripts

Na pasta `backend/functions`:

| Comando | Uso |
|---------|-----|
| `npm install` | Dependências |
| `npm run build` | Compila TypeScript |
| `npm run build:watch` | Compila em modo watch |
| `npm run lint` | ESLint |
| `npm run serve` | Build + emulador só de Functions |
| `npm run deploy` | `firebase deploy --only functions` |
| `npm run logs` | `firebase functions:log` |

Antes do deploy, rode `npm run build` (o script `deploy` do npm já assume build feito em outros fluxos; o `serve` inclui build).

## O que está deployado

| Export | Tipo | Região | Papel |
|--------|------|--------|--------|
| `checkCpfExists` | Callable (`onCall`) | `southamerica-east1` | Dado um CPF, indica se já existe usuário e devolve telefone quando houver |

Implementação: `src/features/authentication/callables/check_cpf_exists.ts` → use case → repositório Firestore.

**Contrato completo** (payload, resposta, exemplos Flutter/JS, deploy pontual, **403 Cloud Run / invoker**): **[docs/chamada-check-cpf-exists.md](docs/chamada-check-cpf-exists.md)**.

O app Flutter deve chamar a callable na **mesma região** (`FirebaseFunctions.instanceFor(region: 'southamerica-east1')`) — já documentado no app em `lib/core/services/auth_functions.dart`.

## Estrutura do código

```
src/
  index.ts                          # exports das functions
  features/authentication/
    callables/                      # triggers HTTP / callable
    usecases/
    repositories/                   # Firestore (ex.: user_repository_firestore)
    domain/                         # entidades e referências de coleção
```

Novas functions: adicionar módulo em `features/…`, exportar em `src/index.ts` e documentar em `docs/` se o contrato for relevante para clientes.

## Segurança e evolução

- A callable atual é pensada para **antes** do login (`request.auth` opcional). `enforceAppCheck: false` no código; revisar quando App Check estiver obrigatório no app.
- O use case de CPF consulta usuários no Firestore conforme a implementação atual do repositório; em escala maior, avaliar índice ou campo dedicado (ver notas em `docs/chamada-check-cpf-exists.md`).

## Monorepo

Este diretório costuma conviver com o app em `app/`. O README na raiz do repositório descreve o conjunto do projeto.
