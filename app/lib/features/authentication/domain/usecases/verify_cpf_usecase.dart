import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_functions.dart';
import 'package:app/features/authentication/data/dtos/login_dto.dart';
import 'package:fpdart/fpdart.dart';

/// Valida CPF no cliente e consulta cadastro via Cloud Function [checkCpfExists].
class VerifyCpfUseCase {
  VerifyCpfUseCase({required AuthFunctionsService authFunctions})
      : _authFunctions = authFunctions;

  final AuthFunctionsService _authFunctions;

  Future<Either<Failure, CheckCpfExistsResult>> call(LoginDto input) async {
    final cpf = input.cpfDigits.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) {
      return const Left(
        ValidationFailure('CPF deve conter 11 dígitos.'),
      );
    }

    try {
      final result = await _authFunctions.checkCpfExists(cpf);
      return Right(result);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
