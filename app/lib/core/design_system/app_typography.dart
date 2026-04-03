import 'package:app/core/design_system/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Escala pela largura lógica (Figma base 375).
double calculateFontSize(double fontSize) {
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalWidth =
      view.physicalSize.width / view.devicePixelRatio;

  final double scaleFactor;
  if (logicalWidth < 380) {
    scaleFactor = 0.8;
  } else if (logicalWidth < 800) {
    scaleFactor = 1.0;
  } else {
    scaleFactor = 1.2;
  }

  return fontSize * scaleFactor;
}

TextStyle _interTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
  Color? color,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    decoration: decoration,
    decorationColor: decorationColor ?? color,
  ).copyWith(fontVariations: const []);
}

TextStyle _outfitTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
  Color? color,
  List<FontFeature>? fontFeatures,
}) {
  return GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontFeatures: fontFeatures,
  ).copyWith(fontVariations: const []);
}

TextStyle _plusJakartaTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
  Color? color,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  ).copyWith(fontVariations: const []);
}

/// Tokens do Figma — use [appTypography] no [BuildContext] nas telas e widgets.
///
/// - **displayHero** — Outfit 36/40/700
/// - **headlineMedium** — Outfit 28/36/700
/// - **headlineSmall** — Outfit 24/32/700
/// - **bodyLarge400** · **bodyLarge500** · **bodyLarge700** — Inter 16/24
/// - **bodyMedium400** — Inter 14/20/400
/// - **bodyMedium500** — Inter 14/20/500 + lining/tabular nums
/// - **bodyMediumLink** — Inter 14/20 sublinhado + numerais tabulares
/// - **labelLargeInter** — Inter Label/Large (16/20/600)
/// - **labelCta** — Plus Jakarta 16/100%/600 (`onPrimary`)
@immutable
class AppTypographyStyles {
  const AppTypographyStyles._({
    required this.colorScheme,
    required this.displayHero,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.bodyLarge400,
    required this.bodyLarge500,
    required this.bodyLarge700,
    required this.bodyMedium400,
    required this.bodyMedium500,
    required this.labelLargeInter,
    required this.labelCta,
  });

  final ColorScheme colorScheme;

  final TextStyle displayHero;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle bodyLarge400;
  final TextStyle bodyLarge500;
  final TextStyle bodyLarge700;
  final TextStyle bodyMedium400;
  final TextStyle bodyMedium500;
  final TextStyle labelLargeInter;
  final TextStyle labelCta;

  /// Body/Medium/400 com sublinhado (links).
  TextStyle bodyMediumLink() {
    final fs = calculateFontSize(14);
    return _interTextStyle(
      fontSize: fs,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
      letterSpacing: 0,
      color: colorScheme.onSurfaceVariant,
      decoration: TextDecoration.underline,
      decorationColor: colorScheme.onSurfaceVariant,
    ).copyWith(
      fontFeatures: const [
        FontFeature.tabularFigures(),
        FontFeature.liningFigures(),
      ],
    );
  }

  factory AppTypographyStyles.of(ColorScheme colorScheme) {
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final onPrimary = colorScheme.onPrimary;

    return AppTypographyStyles._(
      colorScheme: colorScheme,
      displayHero: _outfitTextStyle(
        fontSize: calculateFontSize(36),
        fontWeight: FontWeight.w700,
        height: 40 / 36,
        letterSpacing: 0,
        color: onSurface,
        fontFeatures: const [
          FontFeature.tabularFigures(),
          FontFeature.liningFigures(),
        ],
      ),
      headlineMedium: _outfitTextStyle(
        fontSize: calculateFontSize(28),
        fontWeight: FontWeight.w700,
        height: 36 / 28,
        letterSpacing: 0,
        color: onSurface,
      ),
      headlineSmall: _outfitTextStyle(
        fontSize: calculateFontSize(24),
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: 0,
        color: onSurface,
      ),
      bodyLarge400: _interTextStyle(
        fontSize: calculateFontSize(16),
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0,
        color: onSurface,
      ),
      bodyLarge500: _interTextStyle(
        fontSize: calculateFontSize(16),
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        letterSpacing: 0,
        color: onSurface,
      ),
      bodyLarge700: _interTextStyle(
        fontSize: calculateFontSize(16),
        fontWeight: FontWeight.w700,
        height: 24 / 16,
        letterSpacing: 0,
        color: onSurface,
      ),
      bodyMedium400: _interTextStyle(
        fontSize: calculateFontSize(14),
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0,
        color: onSurfaceVariant,
      ),
      bodyMedium500: _interTextStyle(
        fontSize: calculateFontSize(14),
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0,
        color: onSurfaceVariant,
      ).copyWith(
        fontFeatures: const [
          FontFeature.tabularFigures(),
          FontFeature.liningFigures(),
        ],
      ),
      labelLargeInter: _interTextStyle(
        fontSize: calculateFontSize(16),
        fontWeight: FontWeight.w600,
        height: 20 / 16,
        letterSpacing: 0.1,
        color: AppPalette.textDefault,
      ),
      labelCta: _plusJakartaTextStyle(
        fontSize: calculateFontSize(16),
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: onPrimary,
      ),
    );
  }
}

extension AppTypographyContext on BuildContext {
  AppTypographyStyles get appTypography =>
      AppTypographyStyles.of(Theme.of(this).colorScheme);
}
