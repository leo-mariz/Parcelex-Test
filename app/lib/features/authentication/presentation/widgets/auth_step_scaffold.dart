import 'package:flutter/material.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/widgets/app_circle_back_button.dart';
import '../../../../core/presentation/widgets/keyboard_whole_page_lift.dart';

/// Layout base do fluxo de autenticação / onboarding: área do leading, padding e
/// corpo rolável com largura máxima opcional (igual [CreateAccountPage]).
///
/// Use [bottom] para teclado customizado ou ações fixas no rodapé.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.applyMaxContentWidth = true,
    this.leading,
    this.onBack,
    this.hasMinimumBottomPadding,
    this.resizeToAvoidBottomInset = true,
  });

  /// Conteúdo principal (ex.: [SingleChildScrollView] com o formulário).
  final Widget body;

  /// Opcional: fica abaixo do [Expanded], fora da rolagem (ex.: teclado numérico).
  final Widget? bottom;

  /// Aplica [AppSpacing.contentMaxWidth] centralizado em telas largas.
  final bool applyMaxContentWidth;

  /// Se null, usa [AppCircleBackButton] com [onBack].
  final Widget? leading;

  final VoidCallback? onBack;

  final bool? hasMinimumBottomPadding;

  /// `false` evita que o teclado do sistema empurre o layout (ex.: OTP com teclado custom).
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final hasMinimumBottomPadding = this.hasMinimumBottomPadding ?? true;
    final cs = Theme.of(context).colorScheme;
    final horizontal = AppSpacing.pageHorizontal;
    final maxContent =
        applyMaxContentWidth ? AppSpacing.contentMaxWidth : null;

    Widget expandedChild = body;
    if (maxContent != null) {
      expandedChild = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContent),
          child: body,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: cs.surface,
      body: KeyboardWholePageLift(
        child: SafeArea(
          bottom: bottom == null,
          minimum: hasMinimumBottomPadding ? EdgeInsets.only(bottom: DSSize.height(36)) : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontal,
                  DSSize.height(16),
                  horizontal,
                  DSSize.height(16),
                ),
                child: leading ?? AppCircleBackButton(onPressed: onBack),
              ),
              Expanded(child: expandedChild),
              ?bottom,
            ],
          ),
        ),
      ),
    );
  }
}
