import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";

import {UserRepositoryFirestore} from
  "../repositories/user_repository_firestore.js";
import {CheckCpfExistsUseCase} from
  "../usecases/check_cpf_exists_usecase.js";

if (getApps().length === 0) {
  initializeApp();
}

/**
 * Extrai o campo `cpf` do payload do callable, se for string.
 * @param {unknown} data Corpo recebido em `request.data`.
 * @return {string|undefined} CPF ou `undefined` se inválido.
 */
function readCpfFromData(data: unknown): string | undefined {
  if (data === null || typeof data !== "object") {
    return undefined;
  }
  const cpf = (data as {cpf?: unknown}).cpf;
  return typeof cpf === "string" ? cpf : undefined;
}

/**
 * Callable usada antes do login: não exige Firebase Auth (`request.auth` pode
 * ser `undefined`). Qualquer cliente do app pode invocar.
 *
 * Entrada `{ cpf: string }`, saída `{ exists, phoneNumber }`.
 */
export const checkCpfExists = onCall(
  {
    region: "southamerica-east1",
    /**
     * Pretende marcar o Cloud Run como público; em firebase-functions v7 o
     * `onCall` pode não propagar `invoker` ao deploy. Se aparecer 403 do Run,
     * siga `docs/chamada-check-cpf-exists.md` (gcloud ou Console).
     */
    invoker: "public",
    enforceAppCheck: false,
  },
  async (request) => {
    const cpf = readCpfFromData(request.data);
    if (cpf === undefined || cpf.trim() === "") {
      throw new HttpsError(
        "invalid-argument",
        "Campo cpf (string) é obrigatório.",
      );
    }

    const firestore = getFirestore();
    const repository = new UserRepositoryFirestore(firestore);
    const useCase = new CheckCpfExistsUseCase(repository);
    return useCase.execute(cpf);
  },
);
