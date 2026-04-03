import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import 'app_theme_tokens.dart';

/// Cores semânticas do produto (Figma), combinando [ColorScheme] e [AppThemeTokens].
@immutable
class AppSemanticColors {
  const AppSemanticColors(this._scheme, this._tokens);

  final ColorScheme _scheme;
  final AppThemeTokens _tokens;

  ColorScheme get colorScheme => _scheme;

  // --- Surface ---
  Color get surfaceDefault => _scheme.surface;
  Color get surfaceLight => _scheme.surfaceContainerHighest;
  Color get surfaceDisabled => AppPalette.surfaceDisabled;
  Color get surfaceSuccess => AppPalette.surfaceSuccess;

  /// Figma: Neutral/Gray 950.
  Color get neutralGray950 => AppPalette.neutralGray950;

  // --- Text ---
  /// Texto em cor de marca (Figma: Text/primary).
  Color get textPrimary => AppPalette.textPrimary;
  Color get textDefault => _scheme.onSurface;
  Color get textLight => _scheme.onSurfaceVariant;
  Color get textDisabled => AppPalette.textDisabled;
  Color get textOnPrimary => _scheme.onPrimary;
  Color get textSuccess => _tokens.success;
  Color get textError => AppPalette.textError;

  // --- Border / foco ---
  Color get borderFocus => _scheme.primary;
  Color get borderEnabled => _scheme.outline;
  Color get borderDefault => AppPalette.borderDefault;

  // --- Tokens de extensão ---
  Color get successGreen50 => _tokens.successGreen50;
  Color get keyboardNumberText => _tokens.keyboardNumberText;
  Color get livenessBorder => _tokens.livenessBorder;
  Color get loaderRing => _tokens.loaderRing;

  Color get overlayWhite60 => _tokens.overlayWhite60;
  Color get overlayNeutral3320 => _tokens.overlayNeutral3320;
  Color get overlayBlack5 => _tokens.overlayBlack5;
}

extension AppThemeAccess on BuildContext {
  AppThemeTokens get appTokens {
    return Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
  }

  AppSemanticColors get appColors {
    return AppSemanticColors(Theme.of(this).colorScheme, appTokens);
  }
}
