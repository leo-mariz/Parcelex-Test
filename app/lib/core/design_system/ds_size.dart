import 'dart:ui';

import 'package:flutter/material.dart';

/// Escala valores a partir do canvas Figma (375×812), com clamp para tablets.
abstract final class DSSize {
  static const double figmaWidth = 375;
  static const double figmaHeight = 812;
  static const double minScale = 0.9;
  static const double maxScaleWidth = 1.25;
  static const double maxScaleHeight = 1.18;

  static FlutterView get _view =>
      WidgetsBinding.instance.platformDispatcher.views.first;

  /// Largura lógica útil (dp).
  static double get logicalWidth =>
      _view.physicalSize.width / _view.devicePixelRatio;

  /// Altura lógica útil (dp).
  static double get logicalHeight =>
      _view.physicalSize.height / _view.devicePixelRatio;

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  static double get widthScaleFactor =>
      _clamp(logicalWidth / figmaWidth, minScale, maxScaleWidth);

  static double get heightScaleFactor =>
      _clamp(logicalHeight / figmaHeight, minScale, maxScaleHeight);

  static double width(double value) => value * widthScaleFactor;

  static double height(double value) => value * heightScaleFactor;
}
