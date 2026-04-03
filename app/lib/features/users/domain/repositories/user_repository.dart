import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> create(UserEntity user);

  /// Cache local primeiro; se ausente, remoto e persiste no cache.
  Future<Either<Failure, UserEntity?>> getById(String id);

  /// Cache local primeiro (lista); se vazio, remoto, replica no cache e retorna.
  Future<Either<Failure, List<UserEntity>>> getAll();

  Future<Either<Failure, UserEntity>> update(UserEntity user);

  Future<Either<Failure, Unit>> delete(String id);
}
