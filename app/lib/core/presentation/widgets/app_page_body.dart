import 'package:flutter/material.dart';

import '../../design_system/app_spacing.dart';

/// Envolve o conteúdo de uma tela com padrões do app: SafeArea, padding,
/// largura máxima em telas grandes e scroll opcional (teclado / overflow).
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    super.key,
    required this.child,
    this.scrollable = false,
    this.applyMaxContentWidth = true,
    this.useDesignSystemHorizontalPadding = true,
    this.padding = EdgeInsets.zero,
    this.safeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaMinimum = EdgeInsets.zero,
    this.keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.onDrag,
    this.scrollPhysics = const ClampingScrollPhysics(),
  });

  final Widget child;
  final bool scrollable;
  final bool applyMaxContentWidth;

  /// Quando `true`, soma [AppSpacing.pageHorizontal] à esquerda/direita de [padding].
  final bool useDesignSystemHorizontalPadding;
  final EdgeInsets padding;

  final bool safeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final EdgeInsets safeAreaMinimum;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final ScrollPhysics scrollPhysics;

  @override
  Widget build(BuildContext context) {
    final h =
        useDesignSystemHorizontalPadding ? AppSpacing.pageHorizontal : 0.0;
    final resolvedPadding = EdgeInsets.fromLTRB(
      h + padding.left,
      padding.top,
      h + padding.right,
      padding.bottom,
    );

    Widget content = child;

    if (applyMaxContentWidth) {
      final max = AppSpacing.contentMaxWidth;
      if (max != null) {
        content = Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: max),
            child: content,
          ),
        );
      }
    }

    content = Padding(padding: resolvedPadding, child: content);

    if (scrollable) {
      content = SingleChildScrollView(
        keyboardDismissBehavior: keyboardDismissBehavior,
        physics: scrollPhysics,
        child: content,
      );
    }

    if (safeArea) {
      content = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        left: safeAreaLeft,
        right: safeAreaRight,
        minimum: safeAreaMinimum,
        child: content,
      );
    }

    return content;
  }
}
