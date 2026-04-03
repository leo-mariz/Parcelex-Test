import 'package:dart_mappable/dart_mappable.dart';

part 'onboarding_step.mapper.dart';

/// Etapa atual do onboarding (fonte da verdade no servidor após autenticação).
@MappableEnum()
enum OnboardingStep {
  /// Ainda sem fluxo definido (ex.: recém-criado no cliente antes do primeiro sync).
  none,

  /// Aguardando validação do código enviado por e-mail.
  emailOtpPending,

  /// Dados básicos de cadastro concluídos (nome, e-mail, etc.).
  profileComplete,

  /// Captura / envio de selfie.
  selfie,

  /// Prova de vida (SDK / sessão).
  liveness,

  /// Análise ou confirmação pós-captura (ex.: match face).
  verification,

  /// Fluxo de permissões (notificação, local, biometria).
  permissions,

  /// Onboarding finalizado; app pode ir para home.
  done,
}
