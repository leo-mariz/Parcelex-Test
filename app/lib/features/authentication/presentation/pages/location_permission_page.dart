import 'dart:async';

import 'package:app/core/design_system/app_palette.dart';
import 'package:app/core/presentation/widgets/app_skip_chip.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/config/app_router.gr.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/permissions/location_permission.dart';
import '../../../../core/permissions/permission_prompt_result_from_status.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';

/// Onboarding para compartilhar localização e receber ofertas.
@RoutePage(deferredLoading: true)
class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({
    super.key,
    required this.notificationPermissionResult,
    required this.biometricPermissionResult,
  });

  final PermissionPromptResult notificationPermissionResult;
  final PermissionPromptResult biometricPermissionResult;

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  bool _busy = false;

  Future<void> _submitPermissions(PermissionPromptResult locationResult) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    final dto = PermissionsDto(
      notification: widget.notificationPermissionResult,
      biometric: widget.biometricPermissionResult,
      location: locationResult,
    );
    await context.router.push(
      AuthLoadingRoute(
        cpfMasked: '',
        awaitingUserPermissionsUpdate: true,
        permissionsDto: dto,
      ),
    );
  }

  Future<void> _onShareLocation() async {
    if (_busy) return;
    setState(() => _busy = true);
    final status = await requestLocationWhenInUsePermission();
    if (!mounted) return;
    setState(() => _busy = false);

    final result = permissionPromptResultFromPermissionStatus(status);

    if (status == PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização ativada.')),
      );
      unawaited(_submitPermissions(result));
      return;
    }

    if (status == PermissionStatus.permanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você pode ativar a localização nas configurações do app quando quiser.',
          ),
        ),
      );
      unawaited(_submitPermissions(result));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sem localização, as ofertas podem ser menos relevantes para você.',
        ),
      ),
    );
    unawaited(_submitPermissions(result));
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
                        _submitPermissions(PermissionPromptResult.skipped),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: DSSize.height(16)),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppAssets.localizationIcon,
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
                'Encontre as melhores lojas para você comprar',
                style: typo.headlineSmall,
              ),
              SizedBox(height: AppSpacing.sectionGap),
              Text(
                'Permita o acesso à sua localização para receber melhores ofertas.',
                style: typo.bodyLarge400.copyWith(color: AppPalette.textLight),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Compartilhar localização',
                onPressed: _onShareLocation,
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
