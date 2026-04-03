import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../design_system/ds_size.dart';

/// Botão circular claro com seta para voltar (fluxos empilhados).
class AppCircleBackButton extends StatelessWidget {
  const AppCircleBackButton({
    super.key,
    this.onPressed,
    this.size,
    this.iconSize,
  });

  final VoidCallback? onPressed;
  /// Lado do toque; padrão escala Figma 44.
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final side = size ?? DSSize.width(44);
    final iSize = iconSize ?? DSSize.width(20);

    return Material(
      color: cs.surfaceContainerHighest,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () => context.router.maybePop(),
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: side,
          height: side,
          child: Icon(
            Icons.arrow_back,
            size: iSize,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}
