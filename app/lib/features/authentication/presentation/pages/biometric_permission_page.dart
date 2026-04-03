import 'dart:async';

import 'package:app/core/config/app_router.gr.dart';
import 'package:app/core/config/setup_locator.dart';
import 'package:app/core/design_system/app_palette.dart';
import 'package:app/core/presentation/widgets/app_skip_chip.dart';
import 'package:app/core/services/biometrics_services.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';

/// Onboarding para habilitar acesso por biometria (Face ID / Touch ID).
@RoutePage(deferredLoading: true)
class BiometricPermissionPage extends StatefulWidget {
  const BiometricPermissionPage({
    super.key,
    required this.notificationPermissionResult,
  });

  final PermissionPromptResult notificationPermissionResult;

  @override
  State<BiometricPermissionPage> createState() =>
      _BiometricPermissionPageState();
}

class _BiometricPermissionPageState extends State<BiometricPermissionPage> {
  bool _busy = false;

  IBiometricAuthService get _biometrics => getIt<IBiometricAuthService>();

  Future<void> _goToLocationStep(PermissionPromptResult biometricResult) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    await context.router.push(
      LocationPermissionRoute(
        notificationPermissionResult: widget.notificationPermissionResult,
        biometricPermissionResult: biometricResult,
      ),
    );
  }

  Future<void> _onEnableBiometrics() async {
    if (_busy) return;
    setState(() => _busy = true);

    final available = await _biometrics.isBiometricsAvailable();
    if (!available) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Biometria indisponível neste aparelho ou não configurada nas '
            'configurações do sistema.',
          ),
        ),
      );
      unawaited(_goToLocationStep(PermissionPromptResult.skipped));
      return;
    }

    final ok = await _biometrics.authenticateWithBiometrics();
    if (!mounted) return;
    setState(() => _busy = false);

    final biometricResult =
        ok ? PermissionPromptResult.granted : PermissionPromptResult.denied;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometria habilitada para o app.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Biometria não confirmada. Você pode tentar de novo ou usar outro '
            'método de acesso.',
          ),
        ),
      );
    }
    unawaited(_goToLocationStep(biometricResult));
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
                        _goToLocationStep(PermissionPromptResult.skipped),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: DSSize.height(16)),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppAssets.biometricsIcon,
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
                'Acesso rápido usando biometria',
                style: typo.headlineSmall,
              ),
              SizedBox(height: AppSpacing.sectionGap),
              Text(
                'Deixe sua conta mais segura habilitando o acesso pela '
                'biometria do celular.',
                style: typo.bodyLarge400.copyWith(color: AppPalette.textLight),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Ativar biometria',
                onPressed: _onEnableBiometrics,
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
