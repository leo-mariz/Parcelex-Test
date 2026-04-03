import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_size.dart';

/// Fase visual das caixas OTP (Figma).
enum AppOtpBoxVisualPhase {
  /// Digitando: fundo [AppPalette.surfaceDefault]; só o slot ativo usa
  /// [AppPalette.borderFocus] (mais espessa), os demais [AppPalette.borderEnabled];
  /// dígitos [AppPalette.textDefault].
  editing,

  /// Verificando (código completo): fundo [AppPalette.surfaceDisabled],
  /// borda [AppPalette.borderEnabled], texto [AppPalette.textDisabled].
  verifying,

  /// Sucesso: como [verifying], borda [AppPalette.textSuccess].
  success,

  /// Erro: como [verifying], borda [AppPalette.textError].
  error,
}

/// OTP em caixas quadradas com cantos arredondados (raio base Figma via [DSSize]).
class AppOtpBoxField extends StatelessWidget {
  const AppOtpBoxField({
    super.key,
    required this.length,
    required this.value,
    required this.activeIndex,
    required this.visualPhase,
    this.borderRadius,
  });

  final int length;
  final String value;

  /// Índice do slot ativo (próximo dígito) ou `-1` se nenhum.
  final int activeIndex;

  /// Controla cores de fundo, borda e dígito conforme o fluxo (digitação / API).
  final AppOtpBoxVisualPhase visualPhase;

  /// Se null, usa [DSSize.width(8)] (inputs do app).
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final digitStyle = typo.bodyLarge700;
    final radius = borderRadius ?? DSSize.width(8);
    final editing = visualPhase == AppOtpBoxVisualPhase.editing;

    final fill = editing
        ? AppPalette.surfaceDefault
        : AppPalette.surfaceDisabled;

    final digitColor = editing
        ? AppPalette.textDefault
        : AppPalette.textDisabled;

    return Row(
      children: List.generate(length, (i) {
        final char = i < value.length ? value[i] : '';
        final isActive = activeIndex >= 0 && i == activeIndex;
        final showCaret =
            editing && isActive && char.isEmpty;

        final cellBorderColor = editing
            ? (isActive ? AppPalette.borderFocus : AppPalette.borderEnabled)
            : switch (visualPhase) {
                AppOtpBoxVisualPhase.editing => AppPalette.borderEnabled,
                AppOtpBoxVisualPhase.verifying => AppPalette.borderEnabled,
                AppOtpBoxVisualPhase.success => AppPalette.textSuccess,
                AppOtpBoxVisualPhase.error => AppPalette.textError,
              };
        final borderW = editing && isActive
            ? DSSize.width(1.5)
            : DSSize.width(1);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DSSize.width(4)),
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: cellBorderColor,
                    width: borderW,
                  ),
                ),
                alignment: Alignment.center,
                child: showCaret
                    ? _Caret(color: AppPalette.borderFocus)
                    : Text(
                        char,
                        style: digitStyle.copyWith(color: digitColor),
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Caret extends StatelessWidget {
  const _Caret({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DSSize.width(2),
      height: DSSize.height(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DSSize.height(1)),
      ),
    );
  }
}
