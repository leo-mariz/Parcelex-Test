import 'package:dart_mappable/dart_mappable.dart';

import '../../../../core/enums/authentication/liveness_session_status.dart';

part 'liveness_session_entity.mapper.dart';

/// Sessão de prova de vida (detalhes brutos podem ficar no provedor / storage privado).
@MappableClass()
class LivenessSessionEntity with LivenessSessionEntityMappable {
  LivenessSessionEntity({
    required this.id,
    required this.userId,
    required this.provider,
    this.providerSessionId,
    required this.status,
    this.resultSummary,
    this.rawPayloadRef,
    required this.createdAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String provider;
  final String? providerSessionId;
  final LivenessSessionStatus status;
  final Map<String, dynamic>? resultSummary;
  final String? rawPayloadRef;
  final DateTime createdAt;
  final DateTime? completedAt;
}
