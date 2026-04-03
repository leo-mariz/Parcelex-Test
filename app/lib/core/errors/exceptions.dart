/// Exceções para DataSources e Services.
///
/// DataSources devem lançar apenas exceções tipadas deste módulo.
/// Repositórios convertem em `Failure` usando `ErrorHandler` (`error_handler.dart`).
///
/// Regra: evite `Exception` genérica; prefira uma exceção tipada abaixo.
library;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// Base para exceções do app.
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Rede (sem conexão, timeout, etc.).
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Cache local (falha genérica ao ler/escrever).
class CacheException extends AppException {
  const CacheException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Falha ao ler do cache (I/O, formato, chave corrompida).
class CacheReadException extends CacheException {
  const CacheReadException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheReadException: $message';
}

/// Falha ao gravar no cache.
class CacheWriteException extends CacheException {
  const CacheWriteException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheWriteException: $message';
}

/// Entrada ausente no cache (equivalente lógico a “não encontrado” local).
class CacheNotFoundException extends CacheException {
  const CacheNotFoundException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheNotFoundException: $message';
}

/// Dados locais inconsistentes / desserialização.
class CacheCorruptedException extends CacheException {
  const CacheCorruptedException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheCorruptedException: $message';
}

/// Recurso não encontrado (404, documento inexistente).
class NotFoundException extends AppException {
  const NotFoundException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'NotFoundException: $message';
}

/// Servidor / erro remoto genérico.
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    super.message, {
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'ServerException${statusCode != null ? ' ($statusCode)' : ''}: $message';
}

/// Autenticação (credenciais, token, sessão).
class AuthException extends AppException {
  final String? code;

  const AuthException(
    super.message, {
    this.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'AuthException${code != null ? ' ($code)' : ''}: $message';
}

/// Validação de dados de entrada.
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Dados incompletos.
class IncompleteDataException extends AppException {
  final List<String>? missingFields;

  const IncompleteDataException(
    super.message, {
    this.missingFields,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'IncompleteDataException: $message${missingFields != null ? ' — campos: ${missingFields!.join(', ')}' : ''}';
}

/// Permissão de app / regra de negócio negada.
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'PermissionException: $message';
}

/// Geolocalização / GPS.
class LocationException extends AppException {
  const LocationException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'LocationException: $message';
}

/// Erro retornado por APIs Firebase ([FirebaseException]).
///
/// Use [CloudFirebaseException.fromFirebaseException] a partir de catches do
/// Firestore, Storage, etc.
class CloudFirebaseException extends AppException {
  const CloudFirebaseException(
    super.message, {
    required this.code,
    required this.plugin,
    this.httpStatusApprox,
    super.originalError,
    super.stackTrace,
  });

  final String code;
  final String plugin;
  final int? httpStatusApprox;

  factory CloudFirebaseException.fromFirebaseException(
    FirebaseException e, {
    StackTrace? stackTrace,
  }) {
    return CloudFirebaseException(
      e.message ?? e.code,
      code: e.code,
      plugin: e.plugin,
      httpStatusApprox: firebaseExceptionToApproxHttpStatus(e.code),
      originalError: e,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'CloudFirebaseException ($code, $plugin): $message';
}

/// Mapeia [FirebaseException.code] para status HTTP aproximado (tratamento em UI).
int? firebaseExceptionToApproxHttpStatus(String code) {
  return switch (code) {
    'permission-denied' => 403,
    'not-found' => 404,
    'already-exists' => 409,
    'unavailable' => 503,
    'deadline-exceeded' => 504,
    'resource-exhausted' => 429,
    'failed-precondition' => 412,
    'aborted' => 409,
    'out-of-range' => 400,
    'unimplemented' => 501,
    'internal' => 500,
    'unauthenticated' => 401,
    'cancelled' => 499,
    'data-loss' => 500,
    'invalid-argument' => 400,
    'unknown' => null,
    _ => null,
  };
}

/// Códigos de erro de Callable Functions (backend).
enum CallableErrorCode {
  unauthorized,
  forbidden,
  validation,
  notFound,
  server,
}

/// Callable retornou erro estruturado `{ error: { code, message } }`.
class CallableFunctionException extends AppException {
  const CallableFunctionException(
    super.message, {
    required this.code,
    super.originalError,
    super.stackTrace,
  });

  final CallableErrorCode code;

  @override
  String toString() => 'CallableFunctionException($code): $message';

  static CallableFunctionException? fromResponseMap(Map<String, dynamic>? result) {
    if (result == null) return null;
    final error = result['error'];
    if (error == null || error is! Map) return null;
    final codeStr = (error['code'] as String?)?.toUpperCase();
    final msg = error['message'] as String?;
    if (codeStr == null || codeStr.isEmpty) return null;
    final parsed = _parseCode(codeStr);
    final message = (msg != null && msg.isNotEmpty)
        ? msg
        : _defaultMessageForCode(parsed);
    return CallableFunctionException(
      message,
      code: parsed,
      originalError: result,
    );
  }

  static CallableFunctionException? tryParse(FirebaseFunctionsException? e) {
    if (e == null) return null;
    final details = e.details;
    if (details == null || details is! Map) return null;
    final error = details['error'];
    if (error == null || error is! Map) return null;
    final codeStr = (error['code'] as String?)?.toUpperCase();
    final msg = error['message'] as String?;
    if (codeStr == null || codeStr.isEmpty) return null;
    final parsed = _parseCode(codeStr);
    final message = (msg != null && msg.isNotEmpty)
        ? msg
        : _defaultMessageForCode(parsed);
    return CallableFunctionException(
      message,
      code: parsed,
      originalError: e,
    );
  }

  static CallableErrorCode _parseCode(String codeStr) {
    return switch (codeStr) {
      'UNAUTHORIZED' => CallableErrorCode.unauthorized,
      'FORBIDDEN' => CallableErrorCode.forbidden,
      'VALIDATION' => CallableErrorCode.validation,
      'VALIDAÇÃO' => CallableErrorCode.validation,
      'NOT_FOUND' => CallableErrorCode.notFound,
      'SERVER' => CallableErrorCode.server,
      _ => CallableErrorCode.server,
    };
  }

  static String _defaultMessageForCode(CallableErrorCode code) {
    return switch (code) {
      CallableErrorCode.unauthorized => 'É necessário estar autenticado.',
      CallableErrorCode.forbidden => 'Você não tem permissão para esta ação.',
      CallableErrorCode.validation => 'Dados inválidos.',
      CallableErrorCode.notFound => 'Não encontrado.',
      CallableErrorCode.server => 'Algo deu errado. Tente novamente.',
    };
  }
}
