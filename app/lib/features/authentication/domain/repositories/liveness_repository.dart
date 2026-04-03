import 'package:app/core/errors/failures.dart';
import 'package:app/features/authentication/domain/entities/liveness_session_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class LivenessRepository {
  Future<Either<Failure, LivenessSessionEntity>> create(
    LivenessSessionEntity session,
  );

  /// Cache local primeiro; se ausente, remoto e persiste no cache.
  Future<Either<Failure, LivenessSessionEntity?>> getById(String id);

  /// Cache local primeiro (lista); se vazio, remoto, replica no cache e retorna.
  Future<Either<Failure, List<LivenessSessionEntity>>> getAll();

  Future<Either<Failure, LivenessSessionEntity>> update(
    LivenessSessionEntity session,
  );

  Future<Either<Failure, Unit>> delete(String id);
}
