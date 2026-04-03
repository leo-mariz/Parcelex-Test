import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:fpdart/fpdart.dart';

/// Retorna o UID do usuário autenticado ([AuthService.currentUser]).
class GetUserUidUseCase {
  GetUserUidUseCase({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  Future<Either<Failure, String>> call() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      return const Left(
        AuthFailure('Nenhum usuário autenticado.'),
      );
    }
    return Right(uid);
  }
}
