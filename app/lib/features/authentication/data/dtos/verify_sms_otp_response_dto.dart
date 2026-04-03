import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart';

/// Resposta de [VerifySmsOtpUseCase].
@immutable
class VerifySmsOtpResponseDto {
  const VerifySmsOtpResponseDto({
    required this.uid,
    this.userProfile,
  });

  final String uid;

  /// Perfil após cadastro (create) ou login (getById). Define o próximo passo do onboarding.
  final UserEntity? userProfile;
}
