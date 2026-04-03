import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';
import '../../design_system/ds_size.dart';

/// Exibe [length] slots com sublinhado; o slot ativo recebe destaque.
class AppOtpUnderlineField extends StatelessWidget {
  const AppOtpUnderlineField({
    super.key,
    required this.length,
    required this.value,
    required this.activeIndex,
    this.digitColor,
    this.inactiveLineColor,
    this.activeLineColor,
  });

  final int length;
  final String value;
  final int activeIndex;
  final Color? digitColor;
  final Color? inactiveLineColor;
  final Color? activeLineColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final digitStyle = typo.headlineSmall;
    final dc = digitColor ?? digitStyle.color ?? cs.onSurfaceVariant;
    final inactive = inactiveLineColor ?? cs.outlineVariant;
    final active = activeLineColor ?? cs.secondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (i) {
        final char = i < value.length ? value[i] : '';
        final isActive = activeIndex >= 0 && i == activeIndex;
        final showCaret = isActive && char.isEmpty;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DSSize.width(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: DSSize.height(32),
                  child: Center(
                    child: showCaret
                        ? _Caret(color: active)
                        : Text(
                            char,
                            style: digitStyle.copyWith(color: dc),
                          ),
                  ),
                ),
                SizedBox(height: DSSize.height(8)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: isActive ? DSSize.height(2.2) : DSSize.height(1.2),
                  decoration: BoxDecoration(
                    color: isActive ? active : inactive,
                    borderRadius: BorderRadius.circular(DSSize.width(2)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Caret extends StatelessWidget {
  const _Caret({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DSSize.width(2),
      height: DSSize.height(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DSSize.height(1)),
      ),
    );
  }
}
