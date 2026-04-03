import 'package:app/core/errors/exceptions.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:app/features/users/domain/extensions/user_entity_reference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/firestore_mappable_utils.dart';

/// API remota de [UserEntity] (Firestore).
abstract class UserRemoteDataSource {
  Future<UserEntity> create(UserEntity user);

  Future<UserEntity?> read(String id);

  Future<List<UserEntity>> readAll();

  Future<UserEntity> update(UserEntity user);

  Future<void> delete(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  Future<T> _run<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on FirebaseException catch (e, st) {
      throw CloudFirebaseException.fromFirebaseException(
        e,
        stackTrace: st,
      );
    } catch (e, st) {
      if (e is AppException) rethrow;
      throw ServerException(
        'Erro inesperado no UserRemoteDataSource',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<UserEntity> create(UserEntity user) async {
    return _run(() async {
      final id = user.id;
      if (id == null || id.isEmpty) {
        throw const ValidationException(
          'UserRemoteDataSource.create: UserEntity.id (UID do Firebase Auth) é obrigatório.',
        );
      }
      final col = UserEntityReference.firebaseCollectionReference(_firestore);
      final docRef = col.doc(id);
      final payload = entityMapForFirestoreCreate(user.toMap())..['uid'] = id;
      await docRef.set(payload);
      final snap = await docRef.get();
      final data = snap.data();
      if (data == null) {
        throw const NotFoundException(
          'Documento de usuário criado não retornou dados.',
        );
      }
      return UserEntityMapper.fromMap(
        firestoreDataToMappableMap(data, snap.id),
      );
    });
  }

  @override
  Future<UserEntity?> read(String id) async {
    return _run(() async {
      final ref = UserEntityReference.firebaseUidReference(_firestore, id);
      if (kDebugMode) {
        debugPrint('[UserRemoteDataSource.read] Firestore path=${ref.path}');
      }
      final snap = await ref.get();
      if (kDebugMode) {
        debugPrint(
          '[UserRemoteDataSource.read] exists=${snap.exists} '
          'dataIsNull=${snap.data() == null}',
        );
      }
      if (!snap.exists || snap.data() == null) return null;
      return UserEntityMapper.fromMap(
        firestoreDataToMappableMap(snap.data()!, snap.id),
      );
    });
  }

  @override
  Future<List<UserEntity>> readAll() async {
    return _run(() async {
      final snap =
          await UserEntityReference.firebaseCollectionReference(_firestore)
              .get();
      return snap.docs
          .map(
            (d) => UserEntityMapper.fromMap(
              firestoreDataToMappableMap(d.data(), d.id),
            ),
          )
          .toList();
    });
  }

  @override
  Future<UserEntity> update(UserEntity user) async {
    return _run(() async {
      final id = user.id;
      if (id == null) {
        throw const ValidationException(
          'UserRemoteDataSource.update requer id não nulo.',
        );
      }
      final ref = UserEntityReference.firebaseUidReference(_firestore, id);
      final payload = Map<String, dynamic>.from(user.toMap())..['uid'] = id;
      await ref.update(payload);
      final snap = await ref.get();
      final data = snap.data();
      if (!snap.exists || data == null) {
        throw NotFoundException(
          'Usuário não encontrado após atualização: $id',
        );
      }
      return UserEntityMapper.fromMap(
        firestoreDataToMappableMap(data, snap.id),
      );
    });
  }

  @override
  Future<void> delete(String id) async {
    return _run(() async {
      await UserEntityReference.firebaseUidReference(_firestore, id).delete();
    });
  }
}
