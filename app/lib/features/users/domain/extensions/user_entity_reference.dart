import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension UserEntityReference on UserEntity {
  static DocumentReference<Map<String, dynamic>> firebaseUidReference(
    FirebaseFirestore firestore,
    String uid,
  ) {
    return firebaseCollectionReference(firestore).doc(uid);
  }

  static CollectionReference<Map<String, dynamic>> firebaseCollectionReference(
    FirebaseFirestore firestore,
  ) {
    return firestore.collection('Users');
  }

  static String cachedKey() => 'CACHED_USER_INFO';

  static final List<String> userFields = [
    'email',
    'password',
    'phoneNumber',
  ];
}
