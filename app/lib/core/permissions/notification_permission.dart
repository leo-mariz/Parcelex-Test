import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestNotificationPermission() async {
  if (kIsWeb) {
    return PermissionStatus.granted;
  }
  return Permission.notification.request();
}
