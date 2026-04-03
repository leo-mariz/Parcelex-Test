import 'package:dart_mappable/dart_mappable.dart';

part 'permission_prompt_state_entity.mapper.dart';

/// Preferência de produto para uma permissão de sistema (evita repetir onboarding).
@MappableClass()
class PermissionPromptRecordEntity with PermissionPromptRecordEntityMappable {
  const PermissionPromptRecordEntity({
    this.seen = false,
    this.skipped = false,
    this.completedAt,
  });

  final bool seen;
  final bool skipped;
  final DateTime? completedAt;
}

/// Agregado das telas de permissão (notificação, localização, biometria).
@MappableClass()
class PermissionPromptStateEntity with PermissionPromptStateEntityMappable {
  const PermissionPromptStateEntity({
    this.notification = const PermissionPromptRecordEntity(),
    this.location = const PermissionPromptRecordEntity(),
    this.biometric = const PermissionPromptRecordEntity(),
  });

  final PermissionPromptRecordEntity notification;
  final PermissionPromptRecordEntity location;
  final PermissionPromptRecordEntity biometric;
}
