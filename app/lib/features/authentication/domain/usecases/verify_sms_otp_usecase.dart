import 'package:app/core/errors/error_handler.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/services/auth_services.dart';
import 'package:app/features/authentication/data/dtos/verify_sms_otp_dto.dart';
import 'package:app/features/authentication/data/dtos/verify_sms_otp_response_dto.dart';
import 'package:app/features/authentication/data/mappers/onboarding_user_mapper.dart';
import 'package:app/features/users/domain/usecases/create_user_usecase.dart';
import 'package:app/features/users/domain/usecases/get_user_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Confirma o código SMS e opcionalmente grava o perfil de onboarding no Firestore/cache.
class VerifySmsOtpUseCase {
  VerifySmsOtpUseCase({
    required AuthService authService,
    required GetUserUseCase getUserUseCase,
    required CreateUserUseCase createUserUseCase,
  })  : _auth = authService,
        _getUserUseCase = getUserUseCase,
        _createUserUseCase = createUserUseCase;

  final AuthService _auth;
  final GetUserUseCase _getUserUseCase;
  final CreateUserUseCase _createUserUseCase;

  Future<Either<Failure, VerifySmsOtpResponseDto>> call(VerifySmsOtpDto dto) async {
    final code = dto.smsCode.trim();
    if (dto.verificationId.isEmpty || code.isEmpty) {
      return const Left(
        ValidationFailure('verificationId e código SMS são obrigatórios.'),
      );
    }

    try {
      final credential = await _auth.verifySmsOtp(
        verificationId: dto.verificationId,
        smsCode: code,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        return const Left(AuthFailure('Login não retornou usuário.'));
      }
      final uid = firebaseUser.uid;

      final pending = dto.pendingOnboarding;
      if (pending == null) {
        final profileResult = await _getUserUseCase.call(uid);
        return profileResult.map(
          (user) => VerifySmsOtpResponseDto(uid: uid, userProfile: user),
        );
      }

      final entity = userEntityFromOnboardingDto(dto: pending);
      final saved = await _createUserUseCase.call(
        firebaseAuthUid: uid,
        user: entity,
      );
      return saved.map(
        (user) => VerifySmsOtpResponseDto(uid: uid, userProfile: user),
      );
    } catch (e, st) {
      return Left(ErrorHandler.handle(e, st));
    }
  }
}
