import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_size.dart';

/// Chip pill com fundo [ColorScheme.surfaceContainerHighest] e texto Gray 950.
/// Uso típico: ação “Pular” no canto de telas de onboarding/permissão.
class AppSkipChip extends StatelessWidget {
  const AppSkipChip({
    super.key,
    required this.onPressed,
    this.label = 'Pular',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(DSSize.width(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DSSize.width(16),
            vertical: DSSize.height(10),
          ),
          child: Text(
            label,
            style: typo.bodyMedium500.copyWith(
              color: AppPalette.neutralGray950,
            ),
          ),
        ),
      ),
    );
  }
}
