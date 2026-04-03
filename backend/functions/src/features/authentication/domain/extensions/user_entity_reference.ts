import type {
  CollectionReference,
  DocumentData,
  DocumentReference,
  Firestore,
} from "firebase-admin/firestore";

/** Espelho de `UserEntityReference` do app (Firestore + metadados de cache). */
export const UserEntityReference = {
  firebaseUidReference(
    firestore: Firestore,
    uid: string,
  ): DocumentReference<DocumentData> {
    return UserEntityReference.firebaseCollectionReference(firestore).doc(uid);
  },

  firebaseCollectionReference(
    firestore: Firestore,
  ): CollectionReference<DocumentData> {
    return firestore.collection("Users");
  },

  cachedKey(): string {
    return "CACHED_USER_INFO";
  },

  userFields: ["email", "password", "phoneNumber"] as const,
};
