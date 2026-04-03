import 'package:flutter/material.dart';

import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';
import '../../design_system/ds_size.dart';

/// Linha clicável com ícone em círculo, título, subtítulo e chevron.
class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showDividerBelow = true,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDividerBelow;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: DSPadding.vertical(18)),
              child: Row(
                children: [
                  leading,
                  SizedBox(width: DSSize.width(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: typo.bodyLarge500),
                        SizedBox(height: AppSpacing.gapXs),
                        Text(subtitle, style: typo.bodyMedium400),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),
            if (showDividerBelow)
              Divider(
                height: DSSize.height(1),
                thickness: DSSize.height(1),
                color: cs.outline,
              ),
          ],
        ),
      ),
    );
  }
}

/// Círculo claro com ícone centralizado (SMS, WhatsApp, etc.).
class AppSelectionIconCircle extends StatelessWidget {
  const AppSelectionIconCircle({super.key, required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.secondary;
    final dim = DSSize.width(48);

    return Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: c, size: DSSize.width(24)),
    );
  }
}
