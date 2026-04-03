import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/services/auto_cache_services.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/extensions/user_entity_reference.dart';

/// Cache local de [UserEntity].
abstract class UserLocalDataSource {
  Future<UserEntity> create(UserEntity user);

  Future<UserEntity?> read(String id);

  Future<List<UserEntity>> readAll();

  Future<UserEntity> update(UserEntity user);

  Future<void> delete(String id);
}

/// Persistência via [ILocalCacheService] (chaves com [UserEntityReference.cachedKey]).
class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl(this._cache);

  final ILocalCacheService _cache;

  static String _indexKey() => '${UserEntityReference.cachedKey()}_ids';

  static String _cacheKeyForId(String id) =>
      '${UserEntityReference.cachedKey()}_$id';

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

  bool _isUserPayload(Map<String, dynamic> map) =>
      map.isNotEmpty && map.containsKey('email');

  UserEntity _decodeUser(Map<String, dynamic> map) {
    try {
      return UserEntityMapper.fromMap(map);
    } catch (e, st) {
      throw CacheCorruptedException(
        'Falha ao decodificar UserEntity do cache',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<UserEntity> create(UserEntity user) async {
    final id = user.id ?? 'user_local_${DateTime.now().microsecondsSinceEpoch}';
    final stored = user.copyWith(id: id);
    await _cache.cacheDataString(_cacheKeyForId(id), stored.toMap());
    final ids = await _readIdSet();
    if (!ids.contains(id)) {
      ids.add(id);
      await _writeIdSet(ids);
    }
    return stored;
  }

  @override
  Future<UserEntity?> read(String id) async {
    final raw = await _cache.getCachedDataString(_cacheKeyForId(id));
    if (!_isUserPayload(raw)) return null;
    return _decodeUser(raw);
  }

  @override
  Future<List<UserEntity>> readAll() async {
    final ids = await _readIdSet();
    if (ids.isEmpty) return [];
    final out = <UserEntity>[];
    for (final id in ids) {
      final entity = await read(id);
      if (entity != null) out.add(entity);
    }
    return List<UserEntity>.unmodifiable(out);
  }

  @override
  Future<UserEntity> update(UserEntity user) async {
    final id = user.id;
    if (id == null) {
      throw const ValidationException(
        'UserLocalDataSource.update requer id não nulo.',
      );
    }
    final existing = await _cache.getCachedDataString(_cacheKeyForId(id));
    if (!_isUserPayload(existing)) {
      throw CacheNotFoundException(
        'Usuário não encontrado no cache local: $id',
      );
    }
    await _cache.cacheDataString(_cacheKeyForId(id), user.toMap());
    return user;
  }

  @override
  Future<void> delete(String id) async {
    await _cache.deleteCachedDataString(_cacheKeyForId(id));
    final ids = await _readIdSet();
    if (ids.remove(id)) {
      await _writeIdSet(ids);
    }
  }
}
