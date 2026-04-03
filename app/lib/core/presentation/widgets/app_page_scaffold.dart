import 'package:flutter/material.dart';

import '../../design_system/app_spacing.dart';
import 'app_page_body.dart';
import 'keyboard_whole_page_lift.dart';

/// [Scaffold] padrão: fundo do tema, inset do teclado e corpo com [AppPageBody].
///
/// Com [stickyFooter], o corpo fica em uma área [Expanded] rolável (se
/// [scrollBody] for `true`) e o rodapé permanece fixo abaixo. Nesse modo o
/// [SafeArea] envolve o [Column] inteiro (evita rodapé sob o home indicator).
///
/// Com [useWholePageKeyboardLift] (padrão `true`), o teclado **translada**
/// o corpo inteiro para cima, em vez de só encolher o layout (comportamento
/// próximo ao iOS nas referências do app).
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.body,
    this.stickyFooter,
    this.resizeToAvoidBottomInset = true,
    this.useWholePageKeyboardLift = true,
    this.backgroundColor,
    this.scrollBody = true,
    this.applyMaxContentWidth = true,
    this.useDesignSystemHorizontalPadding = true,
    this.bodyPadding = EdgeInsets.zero,
    this.safeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaMinimum = EdgeInsets.zero,
    this.wrapStickyFooterWithDefaultPadding = false,
    this.stickyFooterBottomPadding,
    /// Quando há [stickyFooter]: `false` deixa a coluna encostar embaixo
    /// (ex.: teclado custom que já trata área segura).
    this.stickyFooterSafeAreaBottom = true,
  });

  /// Conteúdo principal (header, listas, formulário…).
  final Widget body;

  /// Botões ou controles fixos abaixo da área rolável.
  final Widget? stickyFooter;

  /// Só aplicado quando [useWholePageKeyboardLift] é `false`.
  final bool resizeToAvoidBottomInset;

  /// Quando `true`, ignora [resizeToAvoidBottomInset] e usa
  /// [KeyboardWholePageLift] + `resizeToAvoidBottomInset: false`.
  final bool useWholePageKeyboardLift;

  final Color? backgroundColor;

  /// Quando há [stickyFooter], controla o scroll da área superior.
  final bool scrollBody;

  final bool applyMaxContentWidth;
  final bool useDesignSystemHorizontalPadding;
  final EdgeInsets bodyPadding;

  final bool safeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final EdgeInsets safeAreaMinimum;

  /// Se `true`, aplica padding horizontal do DS e [stickyFooterBottomPadding]
  /// embaixo do rodapé (útil para um único botão largo).
  final bool wrapStickyFooterWithDefaultPadding;
  /// Se null, usa [AppSpacing.stickyFooterBottom].
  final double? stickyFooterBottomPadding;

  final bool stickyFooterSafeAreaBottom;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget? footer = stickyFooter;
    if (footer != null && wrapStickyFooterWithDefaultPadding) {
      final x = AppSpacing.pageHorizontal;
      final bottomPad =
          stickyFooterBottomPadding ?? AppSpacing.stickyFooterBottom;
      footer = Padding(
        padding: EdgeInsets.fromLTRB(x, 0, x, bottomPad),
        child: footer,
      );
    }

    final Widget scaffoldBody;
    if (stickyFooter == null) {
      scaffoldBody = AppPageBody(
        scrollable: scrollBody,
        applyMaxContentWidth: applyMaxContentWidth,
        useDesignSystemHorizontalPadding: useDesignSystemHorizontalPadding,
        padding: bodyPadding,
        safeArea: safeArea,
        safeAreaTop: safeAreaTop,
        safeAreaBottom: safeAreaBottom,
        safeAreaLeft: safeAreaLeft,
        safeAreaRight: safeAreaRight,
        safeAreaMinimum: safeAreaMinimum,
        child: body,
      );
    } else {
      scaffoldBody = SafeArea(
        top: safeArea && safeAreaTop,
        bottom: safeArea && stickyFooterSafeAreaBottom,
        left: safeArea && safeAreaLeft,
        right: safeArea && safeAreaRight,
        minimum: safeAreaMinimum,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AppPageBody(
                scrollable: scrollBody,
                applyMaxContentWidth: applyMaxContentWidth,
                useDesignSystemHorizontalPadding:
                    useDesignSystemHorizontalPadding,
                padding: bodyPadding,
                safeArea: false,
                child: body,
              ),
            ),
            footer!,
          ],
        ),
      );
    }

    final effectiveResize =
        useWholePageKeyboardLift ? false : resizeToAvoidBottomInset;

    Widget laidOutBody = scaffoldBody;
    if (useWholePageKeyboardLift) {
      laidOutBody = KeyboardWholePageLift(child: scaffoldBody);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? cs.surface,
      resizeToAvoidBottomInset: effectiveResize,
      body: laidOutBody,
    );
  }
}
