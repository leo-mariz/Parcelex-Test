import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/services/auto_cache_services.dart';
import 'package:app/features/authentication/domain/entities/liveness_session_entity.dart';
import 'package:app/features/authentication/domain/extensions/liveness_session_entity_reference.dart';

/// Cache local de [LivenessSessionEntity].
abstract class LivenessLocalDataSource {
  Future<LivenessSessionEntity> create(LivenessSessionEntity session);

  Future<LivenessSessionEntity?> read(String id);

  Future<List<LivenessSessionEntity>> readAll();

  Future<LivenessSessionEntity> update(LivenessSessionEntity session);

  Future<void> delete(String id);
}

/// Persistência via [ILocalCacheService] (chaves com [LivenessSessionEntityReference.cachedKey]).
class LivenessLocalDataSourceImpl implements LivenessLocalDataSource {
  LivenessLocalDataSourceImpl(this._cache);

  final ILocalCacheService _cache;

  static String _indexKey() => '${LivenessSessionEntityReference.cachedKey()}_ids';

  static String _cacheKeyForSessionId(String id) =>
      '${LivenessSessionEntityReference.cachedKey()}_$id';

  Future<Set<String>> _readIdSet() async {
    final raw = await _cache.getCachedDataString(_indexKey());
    final list = raw['ids'];
    if (list is! List) return {};
    return list.map((e) => e.toString()).toSet();
  }

  Future<void> _writeIdSet(Set<String> ids) async {
    final sorted = ids.toList()..sort();
    await _cache.cacheDataString(_indexKey(), {'ids': sorted});
  }

  bool _isSessionPayload(Map<String, dynamic> map) =>
      map.isNotEmpty &&
      map.containsKey('id') &&
      map.containsKey('userId') &&
      map.containsKey('provider');

  LivenessSessionEntity _decodeSession(Map<String, dynamic> map) {
    try {
      return LivenessSessionEntityMapper.fromMap(map);
    } catch (e, st) {
      throw CacheCorruptedException(
        'Falha ao decodificar LivenessSessionEntity do cache',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<LivenessSessionEntity> create(LivenessSessionEntity session) async {
    await _cache.cacheDataString(
      _cacheKeyForSessionId(session.id),
      session.toMap(),
    );
    final ids = await _readIdSet();
    if (!ids.contains(session.id)) {
      ids.add(session.id);
      await _writeIdSet(ids);
    }
    return session;
  }

  @override
  Future<LivenessSessionEntity?> read(String id) async {
    final raw = await _cache.getCachedDataString(_cacheKeyForSessionId(id));
    if (!_isSessionPayload(raw)) return null;
    return _decodeSession(raw);
  }

  @override
  Future<List<LivenessSessionEntity>> readAll() async {
    final ids = await _readIdSet();
    if (ids.isEmpty) return [];
    final out = <LivenessSessionEntity>[];
    for (final id in ids) {
      final entity = await read(id);
      if (entity != null) out.add(entity);
    }
    return List<LivenessSessionEntity>.unmodifiable(out);
  }

  @override
  Future<LivenessSessionEntity> update(LivenessSessionEntity session) async {
    final existing =
        await _cache.getCachedDataString(_cacheKeyForSessionId(session.id));
    if (!_isSessionPayload(existing)) {
      throw CacheNotFoundException(
        'Sessão de liveness não encontrada no cache local: ${session.id}',
      );
    }
    await _cache.cacheDataString(
      _cacheKeyForSessionId(session.id),
      session.toMap(),
    );
    return session;
  }

  @override
  Future<void> delete(String id) async {
    await _cache.deleteCachedDataString(_cacheKeyForSessionId(id));
    final ids = await _readIdSet();
    if (ids.remove(id)) {
      await _writeIdSet(ids);
    }
  }
}
