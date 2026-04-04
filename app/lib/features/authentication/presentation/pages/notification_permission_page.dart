import 'dart:async';

import 'package:app/core/design_system/app_palette.dart';
import 'package:app/core/presentation/notifications/app_notifications.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/config/app_router.gr.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/permissions/notification_permission.dart';
import '../../../../core/permissions/permission_prompt_result_from_status.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../core/presentation/widgets/app_skip_chip.dart';

/// Onboarding para ativar notificações de pagamentos e avisos.
@RoutePage(deferredLoading: true)
class NotificationPermissionPage extends StatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  State<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends State<NotificationPermissionPage> {
  bool _busy = false;

  Future<void> _goToBiometricStep(PermissionPromptResult notificationResult) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    await context.router.push(
      BiometricPermissionRoute(notificationPermissionResult: notificationResult),
    );
  }

  Future<void> _onEnableNotifications() async {
    if (_busy) return;
    setState(() => _busy = true);
    final status = await requestNotificationPermission();
    if (!mounted) return;
    setState(() => _busy = false);

    final result = permissionPromptResultFromPermissionStatus(status);

    if (status == PermissionStatus.granted) {
      showAppWarning('Notificações ativadas.');
      unawaited(_goToBiometricStep(result));
      return;
    }

    if (status == PermissionStatus.permanentlyDenied) {
      showAppWarning(
        'Ative as notificações nas configurações do app se mudar de ideia.',
      );
      unawaited(_goToBiometricStep(result));
      return;
    }

    showAppWarning(
      'Sem notificações, você pode perder avisos importantes.',
    );
    unawaited(_goToBiometricStep(result));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            DSSize.height(16),
            horizontal,
            DSSize.height(0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppSkipChip(
                    onPressed: () {
                      unawaited(
                        _goToBiometricStep(PermissionPromptResult.skipped),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: DSSize.height(16)),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppAssets.notificationBell,
                  height: DSSize.width(80),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              SizedBox(height: DSSize.height(8)),
              Text(
                'Recomendado',
                style: typo.labelLargeInter.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: DSSize.height(8)),
              Text(
                'Ative as notificações e não esquece nenhum pagamento',
                style: typo.headlineSmall,
              ),
              SizedBox(height: AppSpacing.sectionGap),
              Text(
                'Receba notificações sobre próximos pagamentos e outros avisos '
                'importantes sobre sua conta.',
                style: typo.bodyLarge400.copyWith(color: AppPalette.textLight),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Ativar notificações',
                onPressed: _onEnableNotifications,
                enabled: !_busy,
                textStyle: typo.labelCta,
              ),
              SizedBox(height: DSSize.height(24)),
            ],
          ),
        ),
      ),
    );
  }
}
