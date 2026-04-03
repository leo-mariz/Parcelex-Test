import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Localização enquanto o app está em uso (fluxo típico de ofertas por região).
Future<PermissionStatus> requestLocationWhenInUsePermission() async {
  if (kIsWeb) {
    return PermissionStatus.granted;
  }
  return Permission.locationWhenInUse.request();
}
