import 'package:flutter/material.dart';

/// Ao tocar na tela (fora de gestos que os filhos consomem), remove o foco e
/// fecha o teclado. Use no [MaterialApp.builder] para valer em todo o app.
class DismissKeyboardOnTap extends StatelessWidget {
  const DismissKeyboardOnTap({super.key, required this.child});

  final Widget? child;

  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus,
      behavior: HitTestBehavior.translucent,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
