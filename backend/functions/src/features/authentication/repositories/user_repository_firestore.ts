import type {DocumentData, Firestore} from "firebase-admin/firestore";
import {Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import {UserEntityReference} from
  "../domain/extensions/user_entity_reference.js";
import {
  type UserRepository,
  type UserRepositoryRow,
  userRepositoryRowSchema,
} from "./user_repository.js";

/**
 * Converte valores do Firestore (ex.: Timestamp) para tipos serializáveis.
 * @param {unknown} value Valor bruto vindo do SDK.
 * @return {unknown} Valor decodificado.
 */
function decodeFirestoreValue(value: unknown): unknown {
  if (value instanceof Timestamp) {
    return value.toDate();
  }
  if (value !== null && typeof value === "object" && !Array.isArray(value)) {
    return Object.fromEntries(
      Object.entries(value as Record<string, unknown>).map(([k, v]) => [
        k,
        decodeFirestoreValue(v),
      ]),
    );
  }
  if (Array.isArray(value)) {
    return value.map(decodeFirestoreValue);
  }
  return value;
}

/**
 * [UserRepository] backed pela coleção `Users` no Firestore.
 */
export class UserRepositoryFirestore implements UserRepository {
  /**
   * @param {Firestore} firestore Instância do Admin SDK.
   */
  constructor(private readonly firestore: Firestore) {}

  /**
   * Lista documentos de usuário; inválidos são ignorados com log.
   * @return {Promise<Array<UserRepositoryRow>>} Usuários parseados.
   */
  async getAllUsers(): Promise<UserRepositoryRow[]> {
    const snap = await UserEntityReference.firebaseCollectionReference(
      this.firestore,
    ).get();

    const rows: UserRepositoryRow[] = [];

    for (const doc of snap.docs) {
      const raw = decodeFirestoreValue(doc.data()) as DocumentData;
      const payload = {
        ...raw,
        id: doc.id,
      };

      const parsed = userRepositoryRowSchema.safeParse(payload);
      if (!parsed.success) {
        logger.warn(
          "UserRepositoryFirestore.getAllUsers: documento ignorado",
          {
            documentId: doc.id,
            issues: parsed.error.flatten(),
          },
        );
        continue;
      }
      rows.push(parsed.data);
    }

    return rows;
  }
}
