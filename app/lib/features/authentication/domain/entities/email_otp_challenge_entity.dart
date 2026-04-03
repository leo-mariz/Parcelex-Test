import 'package:dart_mappable/dart_mappable.dart';

part 'email_otp_challenge_entity.mapper.dart';

/// Desafio de código enviado por e-mail.
///
/// [codeHash] fica no servidor; o app só envia o código em texto na validação.
@MappableClass()
class EmailOtpChallengeEntity with EmailOtpChallengeEntityMappable {
  EmailOtpChallengeEntity({
    required this.id,
    required this.userId,
    required this.codeHash,
    required this.expiresAt,
    this.attemptCount = 0,
    this.consumedAt,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String codeHash;
  final DateTime expiresAt;
  final int attemptCount;
  final DateTime? consumedAt;
  final DateTime createdAt;
}
