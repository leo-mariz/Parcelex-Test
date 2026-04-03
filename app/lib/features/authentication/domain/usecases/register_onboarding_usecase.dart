import 'package:app/core/errors/failures.dart';
import 'package:app/core/utils/phone_e164_utils.dart';
import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/authentication/data/dtos/register_onboarding_response_dto.dart';
import 'package:app/features/authentication/data/mappers/onboarding_user_mapper.dart';
import 'package:app/features/authentication/domain/usecases/send_login_sms_usecase.dart';
import 'package:app/features/users/domain/usecases/create_user_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Dispara o SMS de cadastro via [SendLoginSmsUseCase] e, se o login automático ocorrer, persiste o perfil.
class RegisterOnboardingUseCase {
  RegisterOnboardingUseCase({
    required SendLoginSmsUseCase sendLoginSmsUseCase,
    required CreateUserUseCase createUserUseCase,
  })  : _sendLoginSms = sendLoginSmsUseCase,
        _createUserUseCase = createUserUseCase;

  final SendLoginSmsUseCase _sendLoginSms;
  final CreateUserUseCase _createUserUseCase;

  Future<Either<Failure, RegisterOnboardingResponseDto>> call(
    OnboardingDto dto,
  ) async {
    if (!dto.acceptedTerms || !dto.acceptedPrivacyPolicy) {
      return Left(
        LegalAcceptanceRequiredFailure(
          'Aceite os termos e a política de privacidade para continuar.',
          acceptTermsNeeded: !dto.acceptedTerms,
          acceptPrivacyPolicyNeeded: !dto.acceptedPrivacyPolicy,
        ),
      );
    }

    final phoneE164 = brazilPhoneDigitsToE164(dto.phoneDigits);
    if (phoneE164.length < 12) {
      return const Left(
        ValidationFailure('Informe um celular válido com DDD.'),
      );
    }

    if (dto.fullName.trim().isEmpty) {
      return const Left(ValidationFailure('Nome completo é obrigatório.'));
    }
    if (dto.email.trim().isEmpty) {
      return const Left(ValidationFailure('E-mail é obrigatório.'));
    }

    final smsResult = await _sendLoginSms.call(phoneE164);

    switch (smsResult) {
      case Left(:final value):
        return Left(value);
      case Right(:final value):
        final sms = value;
        final uid = sms.autoSignedInUserId;
        if (uid != null) {
          final entity = userEntityFromOnboardingDto(dto: dto);
          final saved = await _createUserUseCase.call(
            firebaseAuthUid: uid,
            user: entity,
          );
          return saved.map(
            (user) => RegisterOnboardingResponseDto(
              sms: sms,
              createdUser: user,
            ),
          );
        }
        return Right(
          RegisterOnboardingResponseDto(
            sms: sms,
            pendingOnboarding: dto,
          ),
        );
    }
  }
}
