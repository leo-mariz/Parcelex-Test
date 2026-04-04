import 'dart:async';

import 'package:flutter/foundation.dart';

/// Tipo de aviso no topo da tela ([AppNotificationsHost]).
enum AppNotificationLevel {
  error,
  warning,
}

@immutable
class AppNotificationSnapshot {
  const AppNotificationSnapshot({
    required this.message,
    required this.level,
  });

  final String message;
  final AppNotificationLevel level;
}

/// Estado global de banners no topo (substitui [ScaffoldMessenger] global).
class AppNotificationsController extends ChangeNotifier {
  AppNotificationSnapshot? _current;
  Timer? _hideTimer;

  AppNotificationSnapshot? get current => _current;

  void show(
    String message,
    AppNotificationLevel level, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    _hideTimer?.cancel();
    _current = AppNotificationSnapshot(message: trimmed, level: level);
    notifyListeners();

    _hideTimer = Timer(duration, dismiss);
  }

  void showError(String message) => show(message, AppNotificationLevel.error);

  void showWarning(String message) =>
      show(message, AppNotificationLevel.warning);

  void dismiss() {
    _hideTimer?.cancel();
    _hideTimer = null;
    if (_current == null) return;
    _current = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }
}
