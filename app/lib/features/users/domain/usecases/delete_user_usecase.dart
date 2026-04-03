import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteUserUseCase {
  DeleteUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<Either<Failure, Unit>> call(String id) =>
      _userRepository.delete(id);
}
