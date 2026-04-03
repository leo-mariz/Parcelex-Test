import 'package:app/features/authentication/domain/entities/liveness_session_entity.dart';
import 'package:app/features/users/domain/extensions/user_entity_reference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension LivenessSessionEntityReference on LivenessSessionEntity {
  static const String sessionsSubcollection = 'LivenessSessions';

  static DocumentReference<Map<String, dynamic>> firebaseSessionDocReference(
    FirebaseFirestore firestore,
    String uid,
    String sessionId,
  ) {
    return firebaseSessionsCollectionReference(firestore, uid).doc(sessionId);
  }

  static CollectionReference<Map<String, dynamic>>
      firebaseSessionsCollectionReference(
    FirebaseFirestore firestore,
    String uid,
  ) {
    return UserEntityReference.firebaseUidReference(firestore, uid)
        .collection(sessionsSubcollection);
  }

  static String cachedKey() => 'CACHED_LIVENESS_SESSION_INFO';

  static final List<String> sessionFields = [
    'userId',
    'provider',
    'providerSessionId',
    'status',
    'resultSummary',
    'rawPayloadRef',
    'createdAt',
    'completedAt',
  ];
}
