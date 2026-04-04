import 'package:app/core/design_system/app_palette.dart';
import 'package:app/core/presentation/notifications/app_notifications_controller.dart';
import 'package:flutter/material.dart';

/// Empilha [child] e, por cima, o banner de notificação no topo (abaixo da status bar).
class AppNotificationsHost extends StatelessWidget {
  const AppNotificationsHost({
    super.key,
    required this.controller,
    required this.child,
  });

  final AppNotificationsController controller;
  final Widget child;

  static const Color _warningBackground = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final data = controller.current;
            if (data == null) return const SizedBox.shrink();

            final bg = data.level == AppNotificationLevel.error
                ? AppPalette.textError
                : _warningBackground;

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(data.message),
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, child) {
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * -12),
                          child: child,
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Material(
                        elevation: 6,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                        color: bg,
                        child: InkWell(
                          onTap: controller.dismiss,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              data.message,
                              style: const TextStyle(
                                color: AppPalette.textWhite,
                                fontSize: 14,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
