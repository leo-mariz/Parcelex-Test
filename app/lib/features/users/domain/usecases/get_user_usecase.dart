import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserUseCase {
  GetUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<Either<Failure, UserEntity?>> call(String id) =>
      _userRepository.getById(id);
}
