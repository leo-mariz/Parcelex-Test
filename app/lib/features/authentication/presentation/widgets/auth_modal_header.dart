import 'package:flutter/material.dart';

import '../../../../core/design_system/app_typography.dart';

class AuthModalHeader extends StatelessWidget {
  const AuthModalHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typo.headlineSmall),
        const SizedBox(height: 10),
        Text(subtitle, style: typo.bodyMedium400),
      ],
    );
  }
}
