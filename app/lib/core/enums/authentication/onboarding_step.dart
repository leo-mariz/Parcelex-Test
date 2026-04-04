import 'package:dart_mappable/dart_mappable.dart';

part 'onboarding_step.mapper.dart';

/// Etapa atual do onboarding (fonte da verdade no servidor após autenticação).
@MappableEnum()
enum OnboardingStep {
  /// Ainda sem fluxo definido (ex.: recém-criado no cliente antes do primeiro sync).
  none,

  /// Dados básicos de cadastro concluídos (nome, e-mail, etc.).
  profileComplete,

  /// Prova de vida (SDK / sessão).
  liveness,

  /// Fluxo de permissões (notificação, local, biometria).
  permissions,

  /// Onboarding finalizado; app pode ir para home.
  done,
}
