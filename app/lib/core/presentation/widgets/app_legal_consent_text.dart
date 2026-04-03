import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../design_system/app_typography.dart';

/// Parágrafo legal com trechos sublinhados e tocáveis.
class AppLegalConsentText extends StatefulWidget {
  const AppLegalConsentText({
    super.key,
    required this.onTermsTap,
    required this.onPrivacyTap,
    required this.onDataprevTap,
  });

  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onDataprevTap;

  @override
  State<AppLegalConsentText> createState() => _AppLegalConsentTextState();
}

class _AppLegalConsentTextState extends State<AppLegalConsentText> {
  late final TapGestureRecognizer _terms;
  late final TapGestureRecognizer _privacy;
  late final TapGestureRecognizer _dataprev;

  @override
  void initState() {
    super.initState();
    _terms = TapGestureRecognizer()..onTap = widget.onTermsTap;
    _privacy = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
    _dataprev = TapGestureRecognizer()..onTap = widget.onDataprevTap;
  }

  @override
  void didUpdateWidget(covariant AppLegalConsentText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _terms.onTap = widget.onTermsTap;
    _privacy.onTap = widget.onPrivacyTap;
    _dataprev.onTap = widget.onDataprevTap;
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    _dataprev.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    /// [height] é múltiplo da fonte (sem [DSSize]).
    final base = typo.bodyMedium400.copyWith(
      height: 1.45,
      color: cs.onSurface,
    );
    final link = typo.bodyMediumLink().copyWith(
      height: 1.45,
      color: cs.onSurface,
      decorationColor: cs.onSurface,
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'Ao continuar, você concorda com os '),
          TextSpan(
            text: 'Termos de Uso',
            style: link,
            recognizer: _terms,
          ),
          const TextSpan(text: ' e '),
          TextSpan(
            text: 'Política de Privacidade',
            style: link,
            recognizer: _privacy,
          ),
          const TextSpan(text: ' da Parcelex e autoriza a consulta à '),
          TextSpan(
            text: 'Dataprev',
            style: link,
            recognizer: _dataprev,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
