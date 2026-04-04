import 'package:app/features/liveness/data/dtos/liveness_dto.dart';

/// Resposta de abertura de sessão de liveness (mock ou API real).
class LivenessInitSessionResult {
  const LivenessInitSessionResult({
    required this.sessionId,
    required this.providerSessionId,
    required this.createdAt,
    this.expiresAt,
  });

  /// Identificador interno da sessão no app / backend.
  final String sessionId;

  /// Id retornado pelo provedor de liveness, quando houver.
  final String providerSessionId;

  final DateTime createdAt;

  /// Opcional: validade da sessão no provedor.
  final DateTime? expiresAt;
}

/// Resultado da análise de liveness após a captura (mock ou API real).
class LivenessAnalysisResult {
  const LivenessAnalysisResult({
    required this.passed,
    this.failureReason,
  });

  final bool passed;

  /// Código ou mensagem curta para UI/logs quando [passed] é `false`.
  final String? failureReason;
}

/// Cliente HTTP/SDK de liveness: início de sessão + envio da captura para análise.
abstract class LivenessApiService {
  Future<LivenessInitSessionResult> initLivenessSession(String userId);

  Future<LivenessAnalysisResult> analyzeLiveness(LivenessDto capture);
}

/// Implementação mock: atrasos configuráveis e [forceAnalysisFailure] para testes.
class LivenessApiMockService implements LivenessApiService {
  LivenessApiMockService({
    this.initDelay = Duration.zero,
    this.analysisDelay = const Duration(seconds: 2),
    this.forceAnalysisFailure = false,
  });

  final Duration initDelay;
  final Duration analysisDelay;

  /// Quando `true`, [analyzeLiveness] sempre retorna falha após o delay.
  final bool forceAnalysisFailure;

  @override
  Future<LivenessInitSessionResult> initLivenessSession(String userId) async {
    await Future<void>.delayed(initDelay);
    final now = DateTime.now();
    final stamp = now.millisecondsSinceEpoch;
    return LivenessInitSessionResult(
      sessionId: 'mock_session_$stamp',
      providerSessionId: 'mock_provider_$stamp',
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<LivenessAnalysisResult> analyzeLiveness(LivenessDto capture) async {
    await Future<void>.delayed(analysisDelay);
    if (forceAnalysisFailure) {
      return const LivenessAnalysisResult(
        passed: false,
        failureReason: 'mock_forced_failure',
      );
    }
    return const LivenessAnalysisResult(passed: true);
  }
}
