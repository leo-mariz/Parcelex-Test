import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Solicita acesso à câmera (mobile). No web retorna `true` para permitir
/// navegar só com a UI.
Future<PermissionStatus> requestCameraPermission() async {
  if (kIsWeb) {
    return PermissionStatus.granted;
  }
  return Permission.camera.request();
}
