import 'package:app/core/errors/exceptions.dart';
import 'package:app/features/authentication/domain/entities/liveness_session_entity.dart';
import 'package:app/features/authentication/domain/extensions/liveness_session_entity_reference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/firestore_mappable_utils.dart';

/// API remota de [LivenessSessionEntity] (Firestore).
abstract class LivenessRemoteDataSource {
  Future<LivenessSessionEntity> create(LivenessSessionEntity session);

  Future<LivenessSessionEntity?> read(String id);

  Future<List<LivenessSessionEntity>> readAll();

  Future<LivenessSessionEntity> update(LivenessSessionEntity session);

  Future<void> delete(String id);
}

class LivenessRemoteDataSourceImpl implements LivenessRemoteDataSource {
  LivenessRemoteDataSourceImpl(this._firestore);

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
        'Erro inesperado no LivenessRemoteDataSource',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<LivenessSessionEntity> create(LivenessSessionEntity session) async {
    return _run(() async {
      final col =
          LivenessSessionEntityReference.firebaseSessionsCollectionReference(
        _firestore,
        session.userId,
      );
      final docRef =
          await col.add(entityMapForFirestoreCreate(session.toMap()));
      await docRef.update({'uid': docRef.id});
      final snap = await docRef.get();
      final data = snap.data();
      if (data == null) {
        throw const NotFoundException(
          'Documento de sessão criado não retornou dados.',
        );
      }
      return LivenessSessionEntityMapper.fromMap(
        firestoreDataToMappableMap(data, snap.id),
      );
    });
  }

  @override
  Future<LivenessSessionEntity?> read(String id) async {
    return _run(() async {
      final snap = await _firestore
          .collectionGroup(LivenessSessionEntityReference.sessionsSubcollection)
          .get();
      for (final d in snap.docs) {
        if (d.id == id) {
          return LivenessSessionEntityMapper.fromMap(
            firestoreDataToMappableMap(d.data(), d.id),
          );
        }
      }
      return null;
    });
  }

  @override
  Future<List<LivenessSessionEntity>> readAll() async {
    return _run(() async {
      final snap = await _firestore
          .collectionGroup(LivenessSessionEntityReference.sessionsSubcollection)
          .get();
      return snap.docs
          .map(
            (d) => LivenessSessionEntityMapper.fromMap(
              firestoreDataToMappableMap(d.data(), d.id),
            ),
          )
          .toList();
    });
  }

  @override
  Future<LivenessSessionEntity> update(LivenessSessionEntity session) async {
    return _run(() async {
      final ref = LivenessSessionEntityReference.firebaseSessionDocReference(
        _firestore,
        session.userId,
        session.id,
      );
      final payload = Map<String, dynamic>.from(session.toMap())
        ..['uid'] = session.id;
      await ref.update(payload);
      final snap = await ref.get();
      final data = snap.data();
      if (!snap.exists || data == null) {
        throw NotFoundException(
          'Sessão não encontrada após atualização: ${session.id}',
        );
      }
      return LivenessSessionEntityMapper.fromMap(
        firestoreDataToMappableMap(data, snap.id),
      );
    });
  }

  @override
  Future<void> delete(String id) async {
    return _run(() async {
      final existing = await read(id);
      if (existing == null) return;
      await LivenessSessionEntityReference.firebaseSessionDocReference(
        _firestore,
        existing.userId,
        id,
      ).delete();
    });
  }
}
