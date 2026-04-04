import 'package:flutter/foundation.dart';

/// Payload da etapa de prova de vida / captura (para o use case chamar SDK ou backend).
@immutable
class LivenessDto {
  const LivenessDto({
    required this.userId,
    this.provider = 'mock',
    this.providerSessionId,
    this.frontImageLocalPath,
    this.selfieSubmissionLocalPath,
    this.capturedAt,
    this.metadata = const {},
  });

  /// Usuário autenticado / em onboarding ao qual a sessão pertence.
  final String userId;

  /// Identificador do provedor de liveness (SDK, parceiro, `mock`, etc.).
  final String provider;

  /// Id de sessão retornado pelo provedor, se houver.
  final String? providerSessionId;

  /// Caminho local da imagem frontal / frame usado na prova, se aplicável.
  final String? frontImageLocalPath;

  /// Caminho da selfie enviada na etapa anterior, se reutilizado na análise.
  final String? selfieSubmissionLocalPath;

  final DateTime? capturedAt;

  /// Dados extras do SDK (scores, versão, etc.) sem acoplar o domínio ao plugin.
  final Map<String, Object?> metadata;
}
