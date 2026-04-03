import 'package:app/core/enums/face_framing/face_framing_phase.dart';
import 'package:equatable/equatable.dart';

/// Resultado de uma análise de frame para a UI (elipse, animações, textos).
class FaceFramingSnapshot extends Equatable {
  const FaceFramingSnapshot({
    required this.phase,
    this.faceWidthFraction,
    this.faceCount = 0,
  });

  /// Estado inicial / sem detecção.
  static const FaceFramingSnapshot initial = FaceFramingSnapshot(
    phase: FaceFramingPhase.noFace,
    faceWidthFraction: null,
    faceCount: 0,
  );

  final FaceFramingPhase phase;

  /// Largura do bbox do maior rosto / largura lógica da imagem (0–1). `null` se [noFace].
  final double? faceWidthFraction;

  final int faceCount;

  @override
  List<Object?> get props => [phase, faceWidthFraction, faceCount];
}
