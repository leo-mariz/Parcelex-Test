import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';

/// Botão em formato pill para ações com countdown (ex.: reenviar código).
class AppTimerActionButton extends StatelessWidget {
  const AppTimerActionButton({
    super.key,
    required this.labelPrefix,
    required this.secondsRemaining,
    this.onPressed,
  });

  final String labelPrefix;
  final int secondsRemaining;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final waiting = secondsRemaining > 0;
    final label = waiting
        ? '$labelPrefix (${secondsRemaining}s)'
        : labelPrefix;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: waiting ? null : onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: DSPadding.vertical(16)),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: AppPalette.surfaceDisabled,
          disabledForegroundColor: cs.onSurfaceVariant,
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: typo.bodyLarge500.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
