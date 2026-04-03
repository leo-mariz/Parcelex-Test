import 'package:app/core/enums/face_framing/face_framing_phase.dart';

/// Limites para classificar [FaceFramingPhase] a partir da fração de largura do rosto.
///
/// Valores típicos; ajuste em device real. Comparar com [faceWidthFraction] do snapshot.
class FaceFramingThresholds {
  const FaceFramingThresholds({
    this.tooFarBelow = 0.18,
    this.tooCloseAbove = 0.42,
  })  : assert(tooFarBelow > 0 && tooFarBelow < 1),
        assert(tooCloseAbove > tooFarBelow && tooCloseAbove <= 1);

  /// Abaixo disso → [FaceFramingPhase.tooFar].
  final double tooFarBelow;

  /// Acima disso → [FaceFramingPhase.tooClose].
  final double tooCloseAbove;

  FaceFramingPhase phaseForWidthFraction(double? widthFraction, {required bool hasFace}) {
    if (!hasFace || widthFraction == null) {
      return FaceFramingPhase.noFace;
    }
    if (widthFraction < tooFarBelow) {
      return FaceFramingPhase.tooFar;
    }
    if (widthFraction > tooCloseAbove) {
      return FaceFramingPhase.tooClose;
    }
    return FaceFramingPhase.framed;
  }
}
