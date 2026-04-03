import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/presentation/app_scaffold_messenger.dart';
import '../../../../core/utils/cpf_digits_validator.dart';
import '../../../../core/utils/email_simple_validator.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/formatters/brazilian_phone_input_formatter.dart';
import '../../../../core/presentation/formatters/cep_input_formatter.dart';
import '../../../../core/presentation/widgets/app_labeled_radio_row.dart';
import '../../../../core/presentation/widgets/app_legal_consent_text.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../core/presentation/widgets/app_rounded_text_field.dart';
import '../widgets/auth_step_scaffold.dart';

/// Cadastro complementar após informar CPF (dados pessoais e consentimento).
@RoutePage(deferredLoading: true)
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    super.key,
    required this.cpfMasked,
  });

  /// CPF já mascarado para exibição (ex.: `999.999.999-99`).
  final String cpfMasked;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();

  bool? _signedWorker;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    appScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onContinue() {
    final cpfDigits = widget.cpfMasked.replaceAll(RegExp(r'\D'), '');
    if (cpfDigits.length != 11 || !isValidBrazilianCpfDigits(cpfDigits)) {
      _showSnack('CPF inválido. Volte e informe novamente.');
      return;
    }

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final cepDigits = _cepController.text.replaceAll(RegExp(r'\D'), '');

    if (fullName.isEmpty) {
      _showSnack('Informe o nome completo.');
      return;
    }
    final nameParts =
        fullName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).length;
    if (nameParts < 2) {
      _showSnack('Informe nome e sobrenome.');
      return;
    }
    if (email.isEmpty) {
      _showSnack('Informe o e-mail.');
      return;
    }
    if (!isValidEmailFormat(email)) {
      _showSnack('Informe um e-mail válido.');
      return;
    }
    if (phoneDigits.length < 10 || phoneDigits.length > 11) {
      _showSnack('Informe um telefone com DDD (10 ou 11 dígitos).');
      return;
    }
    if (cepDigits.length != 8) {
      _showSnack('Informe um CEP com 8 dígitos.');
      return;
    }
    if (_signedWorker == null) {
      _showSnack('Responda se você é trabalhador de carteira assinada.');
      return;
    }

    final dto = OnboardingDto(
      cpfDigits: cpfDigits,
      fullName: fullName,
      email: email,
      phoneDigits: phoneDigits,
      cepDigits: cepDigits,
      isSignedWorker: _signedWorker,
      acceptedTerms: true,
      acceptedPrivacyPolicy: true,
      acceptedDataprevConsent: true,
    );

    context.read<AuthBloc>().add(RegisterOnboardingSubmitted(dto));
    context.router.push(
      AuthLoadingRoute(
        cpfMasked: widget.cpfMasked,
        isRegisterOnboarding: true,
      ),
    );
  }

  void _stubLink(String name) {
    _showSnack('$name — em breve');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    final scrollContent = SingleChildScrollView(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        bottom: DSSize.height(24),
        top: DSSize.height(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Crie sua conta',
            style: typo.headlineSmall,
          ),
          SizedBox(height: AppSpacing.sectionGap),
          Text(
            'CPF: ${widget.cpfMasked}',
            style: typo.bodyLarge700.copyWith(
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: DSSize.height(8)),
          Text(
            'Os dados inseridos devem pertencer ao titular do CPF informado',
            style: typo.bodyMedium400,
          ),
          SizedBox(height: AppSpacing.sectionGap),
          AppRoundedTextField(
            controller: _fullNameController,
            label: 'Nome completo',
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: DSSize.height(16)),
          AppRoundedTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: DSSize.height(16)),
          AppRoundedTextField(
            controller: _phoneController,
            label: 'Celular',
            keyboardType: TextInputType.phone,
            inputFormatters: const [BrazilianPhoneInputFormatter()],
          ),
          SizedBox(height: DSSize.height(16)),
          AppRoundedTextField(
            controller: _cepController,
            label: 'CEP',
            keyboardType: TextInputType.number,
            inputFormatters: const [CepInputFormatter()],
          ),
          SizedBox(height: DSSize.height(24)),
          AppLabeledRadioRow<bool>(
            title: 'Você é trabalhador de carteira assinada?',
            groupValue: _signedWorker,
            onChanged: (v) => setState(() => _signedWorker = v),
            options: const [
              (value: true, label: 'Sim'),
              (value: false, label: 'Não'),
            ],
          ),
          SizedBox(height: DSSize.height(40)),
          AppLegalConsentText(
            onTermsTap: () => _stubLink('Termos de Uso'),
            onPrivacyTap: () => _stubLink('Política de Privacidade'),
            onDataprevTap: () => _stubLink('Dataprev'),
          ),
          SizedBox(height: DSSize.height(16)),
          AppPrimaryButton(
            label: 'Continuar',
            onPressed: _onContinue,
          ),
        ],
      ),
    );

    return AuthStepScaffold(body: scrollContent);
  }
}
