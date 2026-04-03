import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:app/features/permissions/domain/entities/permission_prompt_state_entity.dart';

PermissionPromptRecordEntity _recordFromResult(PermissionPromptResult result) {
  final now = DateTime.now();
  return switch (result) {
    PermissionPromptResult.granted => PermissionPromptRecordEntity(
        seen: true,
        skipped: false,
        completedAt: now,
      ),
    PermissionPromptResult.skipped => PermissionPromptRecordEntity(
        seen: true,
        skipped: true,
        completedAt: now,
      ),
    PermissionPromptResult.denied => PermissionPromptRecordEntity(
        seen: true,
        skipped: false,
        completedAt: now,
      ),
    PermissionPromptResult.permanentlyDenied => PermissionPromptRecordEntity(
        seen: true,
        skipped: false,
        completedAt: now,
      ),
  };
}

/// Converte decisões de UI em [PermissionPromptStateEntity] para persistir no usuário.
PermissionPromptStateEntity permissionStateFromDto(PermissionsDto dto) {
  return PermissionPromptStateEntity(
    notification: _recordFromResult(dto.notification),
    location: _recordFromResult(dto.location),
    biometric: _recordFromResult(dto.biometric),
  );
}
