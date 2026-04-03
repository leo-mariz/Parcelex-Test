import 'package:app/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// TODO: integrar com `permission_handler` / APIs de notificação e persistir preferência.
class EnableNotificationsUseCase {
  EnableNotificationsUseCase();

  Future<Either<Failure, Unit>> call() async {
    return Left(
      UnknownFailure(
        'EnableNotificationsUseCase ainda não implementado.',
      ),
    );
  }
}
