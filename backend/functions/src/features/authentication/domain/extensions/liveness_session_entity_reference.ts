import type {
  CollectionReference,
  DocumentData,
  DocumentReference,
  Firestore,
} from "firebase-admin/firestore";

import {UserEntityReference} from "./user_entity_reference.js";

/** Espelho de `LivenessSessionEntityReference` do app. */
export const LivenessSessionEntityReference = {
  sessionsSubcollection: "LivenessSessions",

  firebaseSessionDocReference(
    firestore: Firestore,
    uid: string,
    sessionId: string,
  ): DocumentReference<DocumentData> {
    return LivenessSessionEntityReference.firebaseSessionsCollectionReference(
      firestore,
      uid,
    ).doc(sessionId);
  },

  firebaseSessionsCollectionReference(
    firestore: Firestore,
    uid: string,
  ): CollectionReference<DocumentData> {
    return UserEntityReference.firebaseUidReference(firestore, uid).collection(
      LivenessSessionEntityReference.sessionsSubcollection,
    );
  },

  cachedKey(): string {
    return "CACHED_LIVENESS_SESSION_INFO";
  },

  sessionFields: [
    "userId",
    "provider",
    "providerSessionId",
    "status",
    "resultSummary",
    "rawPayloadRef",
    "createdAt",
    "completedAt",
  ] as const,
};
