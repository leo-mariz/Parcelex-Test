/// Converte erros da data layer em `Failure` para repositórios / use cases.
///
/// Uso típico em `catch`:
/// ```dart
/// try {
///   await dataSource.read(id);
/// } catch (e, st) {
///   return Left(ErrorHandler.handle(e, st));
/// }
/// ```
library;

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Converte qualquer erro em `Failure`.
  ///
  /// [stackTrace] é repassada para [CloudFirebaseException] quando [error] for [FirebaseException].
  static Failure handle(dynamic error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    if (error is AppException) {
      return _handleAppException(error);
    }

    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(error);
    }

    if (error is FirebaseException) {
      return _handleFirebaseException(error, stackTrace);
    }

    if (error is SocketException ||
        error is TimeoutException ||
        error is HandshakeException ||
        error is http.ClientException) {
      return NetworkFailure(
        'Sem conexão. Verifique sua internet e tente novamente.',
        originalError: error,
      );
    }

    if (error is Exception) {
      return UnknownFailure(
        'Erro inesperado: $error',
        originalError: error,
      );
    }

    return UnknownFailure(
      'Erro desconhecido: $error',
      originalError: error,
    );
  }

  static Failure _handleAppException(AppException exception) {
    return switch (exception) {
      NetworkException() => NetworkFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CacheReadException() => CacheFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CacheWriteException() => CacheFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CacheNotFoundException() => NotFoundFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CacheCorruptedException() => CacheFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CacheException() => CacheFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      NotFoundException() => NotFoundFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      ServerException(statusCode: final code) => ServerFailure(
          exception.message,
          statusCode: code,
          originalError: exception.originalError,
        ),
      AuthException() => AuthFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      ValidationException(fieldErrors: final errors) => ValidationFailure(
          exception.message,
          fieldErrors: errors,
          originalError: exception.originalError,
        ),
      IncompleteDataException(missingFields: final fields) => IncompleteDataFailure(
          exception.message,
          missingFields: fields,
          originalError: exception.originalError,
        ),
      PermissionException() => PermissionFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      LocationException() => NetworkFailure(
          exception.message,
          originalError: exception.originalError,
        ),
      CloudFirebaseException() => _cloudFirebaseToFailure(exception),
      CallableFunctionException(code: final code) => _callableToFailure(
          exception.message,
          code,
          exception.originalError,
        ),
      _ => UnknownFailure(
          exception.message,
          originalError: exception.originalError,
        ),
    };
  }

  static Failure _cloudFirebaseToFailure(CloudFirebaseException e) {
    return switch (e.code) {
      'not-found' => NotFoundFailure(
          e.message,
          originalError: e.originalError,
        ),
      'permission-denied' => PermissionFailure(
          e.message,
          originalError: e.originalError,
        ),
      'unauthenticated' => AuthFailure(
          e.message,
          originalError: e.originalError,
        ),
      'unavailable' ||
      'deadline-exceeded' =>
        NetworkFailure(
          'Sem conexão. Verifique sua internet e tente novamente.',
          originalError: e.originalError,
        ),
      'resource-exhausted' => ServerFailure(
          e.message,
          statusCode: 429,
          originalError: e.originalError,
        ),
      'already-exists' => ServerFailure(
          e.message,
          statusCode: 409,
          originalError: e.originalError,
        ),
      'failed-precondition' ||
      'aborted' =>
        ServerFailure(
          e.message,
          statusCode: e.httpStatusApprox,
          originalError: e.originalError,
        ),
      'cancelled' => ServerFailure(
          e.message,
          statusCode: 499,
          originalError: e.originalError,
        ),
      _ => FirebaseFailure(
          e.message,
          code: e.code,
          plugin: e.plugin,
          approxHttpStatus: e.httpStatusApprox,
          originalError: e.originalError,
        ),
    };
  }

  static Failure _callableToFailure(
    String message,
    CallableErrorCode code,
    dynamic originalError,
  ) {
    return switch (code) {
      CallableErrorCode.unauthorized =>
        AuthFailure(message, originalError: originalError),
      CallableErrorCode.forbidden =>
        PermissionFailure(message, originalError: originalError),
      CallableErrorCode.validation => ValidationFailure(
          message,
          originalError: originalError,
        ),
      CallableErrorCode.notFound => NotFoundFailure(
          message,
          originalError: originalError,
        ),
      CallableErrorCode.server => ServerFailure(
          message,
          originalError: originalError,
        ),
    };
  }

  static Failure _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'user-token-expired' ||
        e.code == 'invalid-user-token' ||
        e.code == 'requires-recent-login' ||
        e.code == 'session-expired') {
      return SessionExpiredFailure(originalError: e);
    }

    final message = switch (e.code) {
      'invalid-credential' => 'Credenciais inválidas',
      'user-not-found' => 'Usuário não encontrado',
      'wrong-password' => 'Senha incorreta',
      'invalid-email' => 'Email inválido',
      'user-disabled' => 'Usuário desabilitado',
      'email-already-in-use' => 'Email já cadastrado',
      'weak-password' => 'Senha muito fraca',
      'too-many-requests' => 'Muitas tentativas. Tente novamente mais tarde',
      'network-request-failed' =>
        'Erro de conexão. Verifique sua internet',
      'operation-not-allowed' => 'Operação não permitida',
      'invalid-verification-code' => 'Código de verificação inválido',
      'invalid-verification-id' =>
        'Link de verificação inválido ou expirado',
      'expired-action-code' => 'Link expirado. Solicite novamente',
      _ => 'Erro de autenticação. Tente novamente.',
    };

    return AuthFailure(message, originalError: e);
  }

  static Failure _handleFirebaseException(
    FirebaseException e, [
    StackTrace? stackTrace,
  ]) {
    return _cloudFirebaseToFailure(
      CloudFirebaseException.fromFirebaseException(
        e,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Status HTTP aproximado para logging / analytics (mesma tabela de [firebaseExceptionToApproxHttpStatus]).
  static int? firebaseStatusCode(FirebaseException e) {
    return firebaseExceptionToApproxHttpStatus(e.code);
  }
}
