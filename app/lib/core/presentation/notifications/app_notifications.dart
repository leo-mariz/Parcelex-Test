import 'package:app/core/config/setup_locator.dart';
import 'package:app/core/presentation/notifications/app_notifications_controller.dart';

export 'package:app/core/presentation/notifications/app_notifications_controller.dart';
export 'package:app/core/presentation/notifications/app_notifications_host.dart';

void showAppError(String message) {
  getIt<AppNotificationsController>().showError(message);
}

void showAppWarning(String message) {
  getIt<AppNotificationsController>().showWarning(message);
}
