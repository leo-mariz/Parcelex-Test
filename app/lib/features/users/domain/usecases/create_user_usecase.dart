import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Cria o documento em `Users/{firebaseAuthUid}` (o [UserRepository] faz `set` nesse id).
class CreateUserUseCase {
  CreateUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  /// [firebaseAuthUid] deve ser o [User.uid] retornado pelo Firebase Auth após o cadastro/login.
  Future<Either<Failure, UserEntity>> call({
    required String firebaseAuthUid,
    required UserEntity user,
  }) {
    final uid = firebaseAuthUid.trim();
    if (uid.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(
            'UID do Firebase Auth é obrigatório para criar o perfil.',
          ),
        ),
      );
    }
    return _userRepository.create(user.copyWith(id: uid));
  }
}
