import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.padding,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Quando `false`, o botão fica visualmente desabilitado e não dispara
  /// [onPressed] (útil para countdown, validação, etc.).
  final bool enabled;

  final Color? backgroundColor;
  /// Padrão: [ColorScheme.onPrimary].
  final Color? foregroundColor;
  /// Padrão: [ColorScheme.surfaceContainerHighest].
  final Color? disabledBackgroundColor;
  /// Padrão: [ColorScheme.onSurfaceVariant].
  final Color? disabledForegroundColor;
  final EdgeInsetsGeometry? padding;
  /// Padrão: [AppTypographyStyles.labelCta].
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final bg = backgroundColor ?? cs.primary;
    final fg = foregroundColor ?? cs.onPrimary;
    final disabledBg = disabledBackgroundColor ?? AppPalette.surfaceDisabled;
    final disabledFg = disabledForegroundColor ?? cs.onSurfaceVariant;
    final effectiveOnPressed = enabled ? onPressed : null;
    final isInteractive = effectiveOnPressed != null;
    final pad = padding ??
        EdgeInsets.symmetric(vertical: DSPadding.vertical(16));
    final style = textStyle ?? typo.labelCta;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          padding: pad,
          backgroundColor: isInteractive ? bg : disabledBg,
          foregroundColor: isInteractive ? fg : disabledFg,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledFg,
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: style,
        ),
        child: Text(label),
      ),
    );
  }
}
