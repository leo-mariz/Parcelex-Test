import 'package:flutter/material.dart';
import '../../design_system/ds_size.dart';

/// Botão de fechar (X) para fluxos modais / telas empilhadas.
class AppCloseButton extends StatelessWidget {
  const AppCloseButton({super.key, this.onPressed, this.color});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = color ?? cs.onSurfaceVariant;

    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
        icon: Icon(Icons.close, size: DSSize.width(22), color: fg),
        style: IconButton.styleFrom(foregroundColor: fg),
      ),
    );
  }
}
