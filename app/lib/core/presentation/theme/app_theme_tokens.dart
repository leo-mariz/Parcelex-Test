import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';

/// Tokens que não têm slot direto no [ColorScheme] do Material 3.
@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.loaderRing,
    required this.success,
    required this.successGreen50,
    required this.keyboardNumberText,
    required this.livenessBorder,
    required this.overlayWhite60,
    required this.overlayNeutral3320,
    required this.overlayBlack5,
  });

  final Color loaderRing;
  final Color success;
  final Color successGreen50;
  final Color keyboardNumberText;
  final Color livenessBorder;
  final Color overlayWhite60;
  final Color overlayNeutral3320;
  final Color overlayBlack5;

  static final AppThemeTokens light = AppThemeTokens(
    loaderRing: AppPalette.loaderRing,
    success: AppPalette.textSuccess,
    successGreen50: AppPalette.successGreen50,
    keyboardNumberText: AppPalette.keyboardNumberText,
    livenessBorder: AppPalette.livenessBorder,
    overlayWhite60: AppPalette.overlayWhite60,
    overlayNeutral3320: AppPalette.overlayNeutral3320,
    overlayBlack5: AppPalette.overlayBlack5,
  );

  @override
  AppThemeTokens copyWith({
    Color? loaderRing,
    Color? success,
    Color? successGreen50,
    Color? keyboardNumberText,
    Color? livenessBorder,
    Color? overlayWhite60,
    Color? overlayNeutral3320,
    Color? overlayBlack5,
  }) {
    return AppThemeTokens(
      loaderRing: loaderRing ?? this.loaderRing,
      success: success ?? this.success,
      successGreen50: successGreen50 ?? this.successGreen50,
      keyboardNumberText: keyboardNumberText ?? this.keyboardNumberText,
      livenessBorder: livenessBorder ?? this.livenessBorder,
      overlayWhite60: overlayWhite60 ?? this.overlayWhite60,
      overlayNeutral3320: overlayNeutral3320 ?? this.overlayNeutral3320,
      overlayBlack5: overlayBlack5 ?? this.overlayBlack5,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      loaderRing: Color.lerp(loaderRing, other.loaderRing, t)!,
      success: Color.lerp(success, other.success, t)!,
      successGreen50: Color.lerp(successGreen50, other.successGreen50, t)!,
      keyboardNumberText:
          Color.lerp(keyboardNumberText, other.keyboardNumberText, t)!,
      livenessBorder: Color.lerp(livenessBorder, other.livenessBorder, t)!,
      overlayWhite60: Color.lerp(overlayWhite60, other.overlayWhite60, t)!,
      overlayNeutral3320:
          Color.lerp(overlayNeutral3320, other.overlayNeutral3320, t)!,
      overlayBlack5: Color.lerp(overlayBlack5, other.overlayBlack5, t)!,
    );
  }
}
