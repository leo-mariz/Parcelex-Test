import 'ds_size.dart';

/// Padding responsivo com base no Figma (375×812) e limites para tablet.
abstract final class DSPadding {
  static double horizontal(double value) => value * DSSize.widthScaleFactor;

  static double vertical(double value) => value * DSSize.heightScaleFactor;
}
