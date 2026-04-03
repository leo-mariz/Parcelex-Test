import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';
import '../../design_system/ds_padding.dart';
import '../../design_system/ds_size.dart';
import '../../design_system/app_palette.dart';

/// Fase visual abaixo do campo OTP (loading / sucesso / erro), sempre centralizada.
enum OtpVerificationPhase {
  idle,
  verifying,
  success,
  error,
}

class AppOtpVerificationFeedback extends StatelessWidget {
  const AppOtpVerificationFeedback({
    super.key,
    required this.phase,
    this.errorMessage = 'Código inválido. Tente novamente.',
    this.verifyingMessage = 'Verificando...',
  });

  final OtpVerificationPhase phase;
  final String errorMessage;
  final String verifyingMessage;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;

    switch (phase) {
      case OtpVerificationPhase.idle:
        return const SizedBox.shrink();
      case OtpVerificationPhase.verifying:
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: DSSize.width(18),
                height: DSSize.height(18),
                child: CircularProgressIndicator(
                  strokeWidth: DSSize.height(2),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: DSSize.width(10)),
              Text(
                verifyingMessage,
                style: typo.bodyMedium400,
              ),
            ],
          ),
        );
      case OtpVerificationPhase.success:
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: DSSize.width(22),
                color: AppPalette.textSuccess,
              ),
              SizedBox(width: DSSize.width(10)),
              Text(
                'Tudo certo!',
                style: typo.bodyMedium400.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppPalette.textSuccess,
                ),
              ),
            ],
          ),
        );
      case OtpVerificationPhase.error:
        final err = Theme.of(context).colorScheme.error;
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DSPadding.horizontal(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: DSSize.width(22),
                  color: err,
                ),
                SizedBox(width: DSSize.width(10)),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: typo.bodyMedium400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: err,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
