import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';
import 'app_theme_tokens.dart';

export 'app_semantic_colors.dart';

/// Ponte para componentes Material que ainda leem [ThemeData.textTheme].
TextTheme _materialTextThemeBridge(AppTypographyStyles typo) {
  return TextTheme(
    displayLarge: typo.displayHero,
    displayMedium: typo.headlineMedium,
    displaySmall: typo.headlineSmall,
    headlineLarge: typo.headlineMedium,
    headlineMedium: typo.headlineMedium,
    headlineSmall: typo.headlineSmall,
    titleLarge: typo.bodyLarge700,
    titleMedium: typo.bodyLarge500,
    titleSmall: typo.bodyMedium400,
    bodyLarge: typo.bodyLarge400,
    bodyMedium: typo.bodyMedium400,
    bodySmall: typo.bodyMedium400,
    labelLarge: typo.labelCta,
    labelMedium: typo.labelLargeInter,
    labelSmall: typo.bodyMedium400,
  );
}

ThemeData buildAppTheme() {
  final primaryContainer = Color.alphaBlend(
    AppPalette.borderFocus.withValues(alpha: 0.14),
    AppPalette.surfaceDefault,
  );

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppPalette.borderFocus,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppPalette.borderFocus,
    onPrimary: AppPalette.textWhite,
    primaryContainer: primaryContainer,
    onPrimaryContainer: AppPalette.textDefault,
    secondary: AppPalette.textPrimary,
    onSecondary: AppPalette.textWhite,
    surface: AppPalette.surfaceDefault,
    onSurface: AppPalette.textDefault,
    onSurfaceVariant: AppPalette.textLight,
    outline: AppPalette.borderEnabled,
    outlineVariant: AppPalette.surfaceDisabled,
    surfaceContainerHighest: AppPalette.surfaceLight,
  );

  final typo = AppTypographyStyles.of(colorScheme);
  final textTheme = _materialTextThemeBridge(typo);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: textTheme,
    extensions: [AppThemeTokens.light],
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        textStyle: typo.labelCta,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: typo.labelLargeInter.copyWith(
          color: colorScheme.secondary,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      hintStyle: typo.bodyMedium400.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
        fontWeight: FontWeight.w400,
      ),
      labelStyle: typo.bodyLarge500,
      floatingLabelStyle: typo.bodyLarge500.copyWith(
        color: colorScheme.primary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: DSPadding.horizontal(16),
        vertical: DSPadding.vertical(16),
      ),
    ),
  );
}
