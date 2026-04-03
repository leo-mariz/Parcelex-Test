import 'package:app/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// TODO: integrar com `permission_handler` (localização) e fluxo de onboarding.
class EnableLocalizationUseCase {
  EnableLocalizationUseCase();

  Future<Either<Failure, Unit>> call() async {
    return Left(
      UnknownFailure(
        'EnableLocalizationUseCase ainda não implementado.',
      ),
    );
  }
}
