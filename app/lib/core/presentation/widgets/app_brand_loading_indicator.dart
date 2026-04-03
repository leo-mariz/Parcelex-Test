import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../design_system/ds_size.dart';
import '../theme/app_semantic_colors.dart';

/// Indicador de marca: ícone central, aro cinza claro e anel de progresso azul por fora.
///
/// Use [center] para substituir o ícone padrão (ex.: variante animada).
class AppBrandLoadingIndicator extends StatelessWidget {
  const AppBrandLoadingIndicator({
    super.key,
    this.extent,
    this.center,
  });

  /// Largura/altura do widget; padrão escala Figma 120.
  final double? extent;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ring = context.appTokens.loaderRing;
    final size = extent ?? DSSize.width(120);

    final innerDisc = size * 0.48;
    final iconSide = innerDisc * 0.52;
    final blueRingDiameter = innerDisc + DSSize.width(18);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: blueRingDiameter,
            height: blueRingDiameter,
            child: CircularProgressIndicator(
              strokeWidth: DSSize.width(2.8),
              color: ring.withValues(alpha: 0.95),
            ),
          ),
          Container(
            width: innerDisc,
            height: innerDisc,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surface,
              border: Border.all(
                color: context.appColors.borderEnabled,
                width: DSSize.width(1),
              ),
            ),
            alignment: Alignment.center,
            child: center ??
                Image.asset(
                  AppAssets.parcelexIcon,
                  width: iconSide,
                  height: iconSide,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
          ),
        ],
      ),
    );
  }
}
