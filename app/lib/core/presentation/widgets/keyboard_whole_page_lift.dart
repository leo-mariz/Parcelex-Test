import 'package:flutter/material.dart';

/// Sobe a tela inteira quando o teclado abre ([MediaQuery.viewInsets]),
/// sem redimensionar o conteúdo (sem “esmagar” espaçamentos).
///
/// Use com [Scaffold.resizeToAvoidBottomInset] = `false` para o corpo manter
/// altura cheia; o deslocamento visual fica alinhado ao topo do teclado.
class KeyboardWholePageLift extends StatelessWidget {
  const KeyboardWholePageLift({
    super.key,
    required this.child,
    this.clip = true,
  });

  final Widget child;

  /// Evita pintar acima da área do [Scaffold] após a translação.
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final dy = MediaQuery.viewInsetsOf(context).bottom;
    final lifted = Transform.translate(
      offset: Offset(0, -dy),
      child: child,
    );
    if (clip) {
      return ClipRect(child: lifted);
    }
    return lifted;
  }
}
