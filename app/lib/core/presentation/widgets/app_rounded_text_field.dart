import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class AppRoundedTextField extends StatelessWidget {
  const AppRoundedTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: typo.bodyLarge500),
          SizedBox(height: AppSpacing.gapXs),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: typo.labelLargeInter,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
