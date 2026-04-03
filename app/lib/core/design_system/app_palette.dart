import 'package:flutter/material.dart';

/// Cores “fonte” do Figma — referências fixas. Na UI, prefira
/// `Theme.of(context).colorScheme` (montado em `app_theme.dart`),
/// `context.appTokens` e `context.appColors` (`app_semantic_colors.dart`).
abstract final class AppPalette {
  // --- Surface ---
  static const Color surfaceDefault = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4F4F5);
  static const Color surfaceDisabled = Color(0xFFE4E4E7);
  /// Figma: Surface/success (ícone + borda do resultado da selfie).
  static const Color surfaceSuccess = Color(0xFF00C950);

  // --- Neutral (Figma) ---
  /// Figma: Neutral/Gray 950 · Gray/950.
  static const Color neutralGray950 = Color(0xFF09090B);

  // --- Text ---
  static const Color textPrimary = Color(0xFF2F90B3);
  static const Color textDefault = neutralGray950;
  static const Color textLight = Color(0xFF71717B);
  /// Texto desabilitado / bloqueado (ex.: OTP durante verificação).
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSuccess = Color(0xFF008236);
  /// Erro (ex.: borda do OTP inválido) — alinhado ao vermelho já usado no app.
  static const Color textError = Color(0xFFC62828);

  // --- Border ---
  static const Color borderFocus = Color(0xFF36A3CA);
  static const Color borderEnabled = Color(0xFFD4D4D8);
  /// Figma: Border/default (trilho neutro, ex.: anel do timer).
  static const Color borderDefault = borderEnabled;

  // --- Success ---
  static const Color successGreen50 = Color(0xFFECFDF5);

  // --- Componentes (nomes do produto) ---
  static const Color keyboardNumberText = Color(0xFF141414);
  static const Color livenessBorder = Color(0xFF53BA14);

  /// Anel / progresso de marca (alinhado ao acento de foco).
  static const Color loaderRing = borderFocus;

  // --- Overlays (opacidade sobre o fundo do layout) ---
  static Color get overlayWhite60 =>
      textWhite.withValues(alpha: 0.6);

  static Color get overlayNeutral3320 =>
      const Color(0xFF333333).withValues(alpha: 0.2);

  static Color get overlayBlack5 =>
      const Color(0xFF000000).withValues(alpha: 0.05);
}
