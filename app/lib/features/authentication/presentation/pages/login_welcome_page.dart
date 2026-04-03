import 'package:app/features/authentication/data/dtos/login_dto.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/presentation/app_scaffold_messenger.dart';
import '../../../../core/utils/cpf_digits_validator.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/formatters/cpf_input_formatter.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../core/presentation/widgets/app_rounded_text_field.dart';
import '../../../../core/presentation/widgets/keyboard_whole_page_lift.dart';
import '../widgets/auth_hero_image.dart';
import '../widgets/parcelex_logo_row.dart';


/// Tela inicial: hero + card com CPF e continuar.
@RoutePage(deferredLoading: true)
class LoginWelcomePage extends StatefulWidget {
  const LoginWelcomePage({super.key});

  @override
  State<LoginWelcomePage> createState() => _LoginWelcomePageState();
}

class _LoginWelcomePageState extends State<LoginWelcomePage> {
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    appScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onContinue() {
    final cpfMasked = _cpfController.text.trim();
    final cpfDigits = cpfMasked.replaceAll(RegExp(r'\D'), '');
    if (cpfDigits.isEmpty) {
      _showSnack('Informe o CPF.');
      return;
    }
    if (cpfDigits.length != 11) {
      _showSnack('O CPF deve ter 11 dígitos.');
      return;
    }
    if (!isValidBrazilianCpfDigits(cpfDigits)) {
      _showSnack('CPF inválido.');
      return;
    }

    context.read<AuthBloc>().add(VerifyCpfSubmitted(LoginDto(cpfDigits: cpfDigits)));
    context.router.push(AuthLoadingRoute(cpfMasked: cpfMasked));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final heroH = AppSpacing.loginHeroHeight;
    final cardTop = AppSpacing.loginCardTop;
    final maxContent = AppSpacing.contentMaxWidth;
    final horizontal = AppSpacing.pageHorizontal;

    Widget formColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            DSSize.width(24),
            DSSize.height(32),
            DSSize.height(24),
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ParcelexLogoRow(height: DSSize.height(36)),
              SizedBox(height: AppSpacing.sectionGap),
              Text(
                'Entre ou cadastre-se',
                style: typo.bodyLarge500,
              ),
              SizedBox(height: AppSpacing.sectionGap),
              AppRoundedTextField(
                controller: _cpfController,
                label: 'CPF',
                keyboardType: TextInputType.number,
                inputFormatters: const [CpfInputFormatter()],
              ),
            ],
          ),
        ),
        SizedBox(height: DSSize.height(24)),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 0),
          child: AppPrimaryButton(
            label: 'Continuar',
            onPressed: _onContinue,
          ),
        ),
      ],
    );

    if (maxContent != null) {
      formColumn = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContent),
          child: formColumn,
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: false,
      body: KeyboardWholePageLift(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: heroH,
              child: const AuthHeroImage(),
            ),
            Positioned(
              top: cardTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(DSSize.height(28))),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.08),
                      blurRadius: DSSize.height(24),
                      offset: Offset(0, -DSSize.height(4)),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  bottom: true,
                  minimum: EdgeInsets.only(bottom: DSSize.height(16)),
                  child: formColumn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
