import 'package:flutter/foundation.dart';

/// Entrada do caso de uso de login (identificação por CPF).
@immutable
class LoginDto {
  const LoginDto({
    required this.cpfDigits,
  });

  /// CPF somente com dígitos (11 caracteres após normalização).
  final String cpfDigits;
}
