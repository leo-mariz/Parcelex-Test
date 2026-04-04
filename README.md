# Parcelex

Repositório do produto **Parcelex** (app mobile **Parceleo**). Aqui ficam o **cliente Flutter** e o **backend serverless** em Firebase Cloud Functions, no mesmo monorepo para manter contratos (ex.: callable `checkCpfExists`) e evolução alinhadas.

## O que há em cada pasta

| Pasta | Conteúdo | Documentação |
|-------|-----------|--------------|
| [`app/`](app/) | Projeto Flutter (onboarding, login por CPF/SMS, Firestore, etc.) | **[app/README.md](app/README.md)** — como rodar, stack, fluxo principal. Material extra em **[app/docs/](app/docs/README.md)** (build iOS, App Check, convenções, docs por feature). |
| [`backend/functions/`](backend/functions/) | Cloud Functions em TypeScript (Gen 2), hoje com a callable de verificação de CPF | **[backend/functions/README.md](backend/functions/README.md)** — scripts, deploy, estrutura. Contrato detalhado da callable em [`backend/functions/docs/chamada-check-cpf-exists.md`](backend/functions/docs/chamada-check-cpf-exists.md). |

Não há outro pacote obrigatório na raiz: configure o **mesmo projeto Firebase** no app e nas functions.

## Por onde começar

1. **Só app:** abra [app/README.md](app/README.md).
2. **Só backend:** abra [backend/functions/README.md](backend/functions/README.md).
3. **Fluxo ponta a ponta:** garanta Firebase + Firestore + Functions deployadas na região esperada pelo app (`southamerica-east1` para a callable atual).
