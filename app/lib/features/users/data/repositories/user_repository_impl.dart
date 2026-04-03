import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:flutter/foundation.dart';
import 'package:app/features/users/data/datasources/user_local_data_source.dart';
import 'package:app/features/users/data/datasources/user_remote_data_source.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserLocalDataSource local,
    required UserRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final UserLocalDataSource _local;
  final UserRemoteDataSource _remote;

  @override
  Future<Either<Failure, UserEntity>> create(UserEntity user) async {
    try {
      final created = await _remote.create(user);
      await _local.create(created);
      return Right(created);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getById(String id) async {
    try {
      if (kDebugMode) {
        debugPrint('[UserRepository.getById] id="$id"');
      }
      final cached = await _local.read(id);
      if (cached != null) {
        if (kDebugMode) {
          debugPrint(
            '[UserRepository.getById] cache hit id=${cached.id} '
            'onboardingStep=${cached.onboardingStep}',
          );
        }
        return Right(cached);
      }
      if (kDebugMode) {
        debugPrint('[UserRepository.getById] cache miss → remote.read');
      }

      final fromRemote = await _remote.read(id);
      if (fromRemote == null) {
        if (kDebugMode) {
          debugPrint(
            '[UserRepository.getById] remote retornou null (sem doc / id inexistente no Firestore?)',
          );
        }
        return const Right(null);
      }
      if (kDebugMode) {
        debugPrint(
          '[UserRepository.getById] remote hit id=${fromRemote.id} → persistindo cache',
        );
      }
      await _local.create(fromRemote);
      return Right(fromRemote);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[UserRepository.getById] exceção: $e\n$st');
      }
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAll() async {
    try {
      final cached = await _local.readAll();
      if (cached.isNotEmpty) return Right(cached);

      final list = await _remote.readAll();
      for (final u in list) {
        final uid = u.id;
        if (uid == null) continue;
        await _local.create(u);
      }
      return Right(list);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> update(UserEntity user) async {
    try {
      final updated = await _remote.update(user);
      await _local.update(updated);
      return Right(updated);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.delete(id);
      return const Right(unit);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
