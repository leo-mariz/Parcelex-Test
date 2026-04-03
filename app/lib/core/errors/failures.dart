/// Failures para `Either<Failure, T>` (ou retornos explícitos na domain layer).
///
/// Repositórios convertem exceções em [Failure] usando `ErrorHandler` em `error_handler.dart`.
library;

/// Base para falhas de domínio / apresentação.
abstract class Failure {
  final String message;
  final dynamic originalError;

  const Failure(this.message, {this.originalError});

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.originalError});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.originalError});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.originalError});
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    this.statusCode,
    super.originalError,
  });

  final int? statusCode;

  @override
  String toString() => statusCode != null
      ? 'ServerFailure ($statusCode): $message'
      : 'ServerFailure: $message';
}

/// Falha alinhada a erro Firebase (código + plugin opcional).
class FirebaseFailure extends Failure {
  const FirebaseFailure(
    super.message, {
    required this.code,
    this.plugin,
    this.approxHttpStatus,
    super.originalError,
  });

  final String code;
  final String? plugin;
  final int? approxHttpStatus;

  @override
  String toString() =>
      'FirebaseFailure ($code${approxHttpStatus != null ? ', ~$approxHttpStatus' : ''}): $message';
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.originalError});
}

class SessionExpiredFailure extends Failure {
  static const String defaultMessage =
      'Sua sessão expirou. Faça login novamente.';

  const SessionExpiredFailure({
    String? message,
    super.originalError,
  }) : super(message ?? SessionExpiredFailure.defaultMessage);
}

class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    this.fieldErrors,
    super.originalError,
  });

  final Map<String, String>? fieldErrors;
}

class IncompleteDataFailure extends Failure {
  const IncompleteDataFailure(
    super.message, {
    this.missingFields,
    super.originalError,
  });

  final List<String>? missingFields;
}

class LegalAcceptanceRequiredFailure extends Failure {
  const LegalAcceptanceRequiredFailure(
    super.message, {
    required this.acceptTermsNeeded,
    required this.acceptPrivacyPolicyNeeded,
    super.originalError,
  });

  final bool acceptTermsNeeded;
  final bool acceptPrivacyPolicyNeeded;
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.originalError});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.originalError});
}

extension FailureSessionX on Failure {
  bool get isSessionExpired => this is SessionExpiredFailure;
}
