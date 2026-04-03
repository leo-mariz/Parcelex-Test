/// Fase de enquadramento do rosto para guiar zoom / “aproxime” na UI customizada.
enum FaceFramingPhase {
  /// Nenhum rosto detectado (ou frame inválido para ML Kit).
  noFace,

  /// Rosto pequeno no frame — UI pode pedir para aproximar.
  tooFar,

  /// Dentro da faixa desejada de tamanho.
  framed,

  /// Rosto grande demais — UI pode pedir para afastar.
  tooClose,
}
