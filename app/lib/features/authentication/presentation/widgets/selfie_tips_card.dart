import 'package:flutter/material.dart';

import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/ds_size.dart';

/// Card com dicas para captura da selfie (iluminação, acessórios).
class SelfieTipsCard extends StatelessWidget {
  const SelfieTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DSSize.width(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(DSSize.width(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dicas para a foto',
              style: typo.bodyLarge500.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: DSSize.height(16)),
            _TipLine(
              icon: Icons.light_mode_outlined,
              text: 'Procure um ambiente bem iluminado',
            ),
            SizedBox(height: DSSize.height(8)),
            _TipLine(
              icon: Icons.person_outline_rounded,
              text: 'Retire acessórios como óculos e boné',
            ),
          ],
        ),
      ),
    );
  }
}

class _TipLine extends StatelessWidget {
  const _TipLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: DSSize.width(22), color: cs.onSurface),
        SizedBox(width: DSSize.width(12)),
        Expanded(
          child: Text(
            text,
            style: typo.bodyMedium400.copyWith(color: cs.onSurface),
          ),
        ),
      ],
    );
  }
}
