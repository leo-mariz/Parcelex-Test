import 'package:flutter/foundation.dart';

/// Resultado da interação do usuário em cada tela de permissão do sistema.
enum PermissionPromptResult {
  /// Usuário concedeu a permissão (ou já estava concedida e confirmamos).
  granted,

  /// Usuário usou “Pular” / fechou sem conceder.
  skipped,

  /// Permissão negada (ainda reversível nas configurações).
  denied,

  /// Negada de forma persistente (“não perguntar de novo”).
  permanentlyDenied,
}

/// Agregado das decisões de notificação, localização e biometria.
@immutable
class PermissionsDto {
  const PermissionsDto({
    required this.notification,
    required this.location,
    required this.biometric,
  });

  final PermissionPromptResult notification;
  final PermissionPromptResult location;
  final PermissionPromptResult biometric;
}
