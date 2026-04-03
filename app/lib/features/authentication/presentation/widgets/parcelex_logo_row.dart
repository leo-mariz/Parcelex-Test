import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

/// Logo via asset; se o arquivo ainda não existir, mostra fallback tipográfico.
class ParcelexLogoRow extends StatelessWidget {
  const ParcelexLogoRow({super.key, this.height = 28});

  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Image.asset(
      AppAssets.parcelexLogo,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _TextLogoFallback(height: height, colorScheme: cs),
    );
  }
}

class _TextLogoFallback extends StatelessWidget {
  const _TextLogoFallback({
    required this.height,
    required this.colorScheme,
  });

  final double height;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final fontSize = height * 0.82;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'parceleo',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: colorScheme.onSurface.withValues(alpha: 0.92),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Text(
            'x',
            style: TextStyle(
              fontSize: fontSize * 1.05,
              fontWeight: FontWeight.w800,
              color: colorScheme.secondary,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
