import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/features/authentication/data/dtos/send_login_sms_response_dto.dart';
import 'package:fpdart/fpdart.dart';

/// Envia SMS de verificação ([AuthService.signInWithSms]) para [phoneNumber] em E.164.
class SendLoginSmsUseCase {
  SendLoginSmsUseCase({required AuthService authService}) : _auth = authService;

  final AuthService _auth;

  Future<Either<Failure, SendLoginSmsResponseDto>> call(
    String phoneNumber, {
    int? forceResendingToken,
  }) async {
    final e164 = phoneNumber.trim();
    if (e164.isEmpty) {
      return const Left(ValidationFailure('Número de telefone é obrigatório.'));
    }
    if (!e164.startsWith('+')) {
      return const Left(
        ValidationFailure('Telefone deve estar no formato internacional (E.164).'),
      );
    }

    try {
      final challenge = await _auth.signInWithSms(
        e164,
        forceResendingToken: forceResendingToken,
      );
      final cred = challenge.userCredential;
      final autoUid = cred?.user?.uid;

      return Right(
        SendLoginSmsResponseDto(
          phoneNumberE164: e164,
          verificationId: challenge.verificationId,
          forceResendingToken: challenge.forceResendingToken,
          needsManualOtp: challenge.needsManualOtp,
          autoSignedInUserId: autoUid,
        ),
      );
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
