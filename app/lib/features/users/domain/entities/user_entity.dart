import 'package:dart_mappable/dart_mappable.dart';
import '../../../../core/enums/authentication/onboarding_step.dart';
import '../../../permissions/domain/entities/permission_prompt_state_entity.dart';
part 'user_entity.mapper.dart';

/// Conta do usuário autenticado.
///
/// [cpfFingerprint] existe no servidor (hash/HMAC); o cliente em geral não o recebe.
@MappableClass()
class UserEntity with UserEntityMappable {
  UserEntity({
    this.id,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.onboardingStep,
    this.permissionPrompts = const PermissionPromptStateEntity(),
    required this.createdAt,
    required this.updatedAt,
    this.cpf,
  });

  final String? id;
  final String email;
  final String phoneNumber;
  final String fullName;
  final OnboardingStep onboardingStep;
  final PermissionPromptStateEntity permissionPrompts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cpf;
}
