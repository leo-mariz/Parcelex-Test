import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:permission_handler/permission_handler.dart';

PermissionPromptResult permissionPromptResultFromPermissionStatus(
  PermissionStatus status,
) {
  return switch (status) {
    PermissionStatus.granted ||
    PermissionStatus.limited ||
    PermissionStatus.provisional =>
      PermissionPromptResult.granted,
    PermissionStatus.permanentlyDenied =>
      PermissionPromptResult.permanentlyDenied,
    PermissionStatus.denied => PermissionPromptResult.denied,
    PermissionStatus.restricted => PermissionPromptResult.denied,
  };
}
