import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';
import '../../design_system/ds_size.dart';

/// Título + opções estilo rádio em linha (ex.: Sim / Não).
class AppLabeledRadioRow<T extends Object> extends StatelessWidget {
  const AppLabeledRadioRow({
    super.key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.options,
  });

  final String title;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final List<({T value, String label})> options;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: typo.labelLargeInter
        ),
        SizedBox(height: DSPadding.vertical(12)),
        Row(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) SizedBox(width: DSSize.width(24)),
              _RadioChip<T>(
                label: options[i].label,
                selected: groupValue == options[i].value,
                onTap: () => onChanged(options[i].value),
                labelStyle: typo.bodyLarge400,
                colorScheme: cs,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _RadioChip<T> extends StatelessWidget {
  const _RadioChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.labelStyle,
    required this.colorScheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? labelStyle;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final border = colorScheme.outline;
    final active = colorScheme.secondary;
    final dot = DSSize.width(22);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DSSize.width(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: DSPadding.vertical(4),
          horizontal: DSSize.width(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: dot,
              height: dot,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? active : border,
                    width: selected ? DSSize.width(2) : DSSize.width(1.2),
                  ),
                  color: Colors.transparent,
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: DSSize.width(10),
                          height: DSSize.width(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: DSSize.width(8)),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
