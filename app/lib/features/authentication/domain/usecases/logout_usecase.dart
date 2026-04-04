import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/core/services/auto_cache_services.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUseCase {
  LogoutUseCase({required AuthService authService, required ILocalCacheService localCacheService}) : _authService = authService, _localCacheService = localCacheService;

  final AuthService _authService;
  final ILocalCacheService _localCacheService;

  Future<Either<Failure, Unit>> call() async {
    try {
      await _authService.logout();
      await _localCacheService.clearCache();
      return const Right(unit);
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
