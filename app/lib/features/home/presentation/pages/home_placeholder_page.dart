import 'package:app/core/design_system/app_typography.dart';
import 'package:app/core/presentation/theme/app_semantic_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Placeholder da home pós-onboarding (texto central, fundo de superfície).
@RoutePage(deferredLoading: true)
class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typo = context.appTypography;

    return Scaffold(
      backgroundColor: colors.surfaceDefault,
      body: Center(
        child: Text(
          'Entrou na plataforma',
          textAlign: TextAlign.center,
          style: typo.headlineMedium.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
