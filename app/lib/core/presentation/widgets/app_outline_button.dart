import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';
import '../../design_system/ds_size.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bc = borderColor ?? cs.secondary;
    final tc = textColor ?? cs.secondary;
    final typo = context.appTypography;
    final pad = padding ??
        EdgeInsets.symmetric(vertical: DSPadding.vertical(16));

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: pad,
          foregroundColor: tc,
          side: BorderSide(color: bc, width: DSSize.width(1.2)),
          shape: const StadiumBorder(),
          textStyle: typo.bodyLarge500.copyWith(fontWeight: FontWeight.w600),
        ),
        child: Text(label, style: TextStyle(color: tc)),
      ),
    );
  }
}
