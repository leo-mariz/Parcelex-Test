import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/authentication/data/datasources/liveness_local_data_source.dart';
import 'package:app/features/authentication/data/datasources/liveness_remote_data_source.dart';
import 'package:app/features/authentication/domain/entities/liveness_session_entity.dart';
import 'package:app/features/authentication/domain/repositories/liveness_repository.dart';
import 'package:fpdart/fpdart.dart';

class LivenessRepositoryImpl implements LivenessRepository {
  LivenessRepositoryImpl({
    required LivenessLocalDataSource local,
    required LivenessRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final LivenessLocalDataSource _local;
  final LivenessRemoteDataSource _remote;

  @override
  Future<Either<Failure, LivenessSessionEntity>> create(
    LivenessSessionEntity session,
  ) async {
    try {
      final created = await _remote.create(session);
      await _local.create(created);
      return Right(created);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, LivenessSessionEntity?>> getById(String id) async {
    try {
      final cached = await _local.read(id);
      if (cached != null) return Right(cached);

      final fromRemote = await _remote.read(id);
      if (fromRemote == null) return const Right(null);

      await _local.create(fromRemote);
      return Right(fromRemote);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, List<LivenessSessionEntity>>> getAll() async {
    try {
      final cached = await _local.readAll();
      if (cached.isNotEmpty) return Right(cached);

      final list = await _remote.readAll();
      for (final s in list) {
        await _local.create(s);
      }
      return Right(list);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }

  @override
  Future<Either<Failure, LivenessSessionEntity>> update(
    LivenessSessionEntity session,
  ) async {
    try {
      final updated = await _remote.update(session);
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
