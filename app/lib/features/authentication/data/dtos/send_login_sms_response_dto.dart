import 'package:flutter/foundation.dart';

/// Resposta de [SendLoginSmsUseCase] após [AuthService.signInWithSms].
@immutable
class SendLoginSmsResponseDto {
  const SendLoginSmsResponseDto({
    required this.phoneNumberE164,
    this.verificationId,
    this.forceResendingToken,
    required this.needsManualOtp,
    this.autoSignedInUserId,
  });

  /// Número para o qual o SMS foi enviado (E.164), preservado nas telas/estados seguintes.
  final String phoneNumberE164;

  /// Presente quando o usuário deve digitar o código SMS manualmente.
  final String? verificationId;

  /// Token para reenvio de SMS (Firebase), quando disponível.
  final int? forceResendingToken;

  /// `true` se for necessário chamar [AuthService.verifySmsOtp] com [verificationId].
  final bool needsManualOtp;

  /// Preenchido quando o Android conclui o login automaticamente (sem OTP manual).
  final String? autoSignedInUserId;
}
