import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';
import '../../design_system/ds_size.dart';

class AppInlineLoadingRow extends StatelessWidget {
  const AppInlineLoadingRow({
    super.key,
    required this.message,
    this.color,
    this.strokeWidth,
    this.size,
  });

  final String message;
  final Color? color;
  final double? strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final c = color ?? cs.onSurfaceVariant;
    final box = size ?? DSSize.width(18);
    final stroke = strokeWidth ?? DSSize.height(2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: box,
          height: box,
          child: CircularProgressIndicator(
            strokeWidth: stroke,
            color: c,
          ),
        ),
        SizedBox(width: DSSize.width(10)),
        Text(
          message,
          style: typo.bodyMedium400.copyWith(
            fontWeight: FontWeight.w500,
            color: c,
          ),
        ),
      ],
    );
  }
}
