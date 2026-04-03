import 'package:flutter/foundation.dart';

/// Dados coletados na etapa de cadastro / onboarding (tela “Crie sua conta” e afins).
@immutable
class OnboardingDto {
  const OnboardingDto({
    required this.cpfDigits,
    required this.fullName,
    required this.email,
    required this.phoneDigits,
    required this.cepDigits,
    this.isSignedWorker,
    this.acceptedTerms = false,
    this.acceptedPrivacyPolicy = false,
    this.acceptedDataprevConsent = false,
  });

  /// CPF do titular (apenas dígitos), já validado no passo anterior.
  final String cpfDigits;

  final String fullName;
  final String email;

  /// Celular (apenas dígitos, ex.: DDD + número).
  final String phoneDigits;

  /// CEP (apenas dígitos).
  final String cepDigits;

  /// “Trabalhador de carteira assinada?” — `null` se o usuário ainda não escolheu.
  final bool? isSignedWorker;

  final bool acceptedTerms;
  final bool acceptedPrivacyPolicy;
  final bool acceptedDataprevConsent;
}
