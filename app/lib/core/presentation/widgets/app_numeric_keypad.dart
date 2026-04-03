import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';

import '../../design_system/app_palette.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/ds_size.dart';
import '../theme/app_semantic_colors.dart';

typedef KeypadDigitCallback = void Function(String digit);
typedef KeypadBackspaceCallback = void Function();

/// Família SF Compact em plataformas Apple; Android/Web usam a fonte do tema.
String? _keypadFontFamily() {
  if (kIsWeb) return null;
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => '.SF Compact Text',
    _ => null,
  };
}

/// Figma: 23/28, wght 457 → [FontWeight.w500] + variação quando suportada.
TextStyle _keypadDigitStyle(Color color) {
  final ff = _keypadFontFamily();
  final fs = calculateFontSize(23);
  final useAxis = ff != null;
  return TextStyle(
    fontFamily: ff,
    fontFamilyFallback: ff == null ? const ['Roboto', 'sans-serif'] : null,
    fontSize: fs,
    height: 28 / 23,
    letterSpacing: 0,
    fontWeight: useAxis ? null : FontWeight.w500,
    fontVariations: useAxis
        ? const [
            FontVariation('wght', 457),
          ]
        : null,
    color: color,
  );
}

/// Figma: 13/15, wght 556, letter-spacing 2px.
TextStyle _keypadLettersStyle(Color color) {
  final ff = _keypadFontFamily();
  final fs = calculateFontSize(13);
  final useAxis = ff != null;
  return TextStyle(
    fontFamily: ff,
    fontFamilyFallback: ff == null ? const ['Roboto', 'sans-serif'] : null,
    fontSize: fs,
    height: 15 / 13,
    letterSpacing: DSSize.width(2),
    fontWeight: useAxis ? null : FontWeight.w600,
    fontVariations: useAxis
        ? const [
            FontVariation('wght', 556),
          ]
        : null,
    color: color,
  );
}

/// Teclado numérico estilo discador (Figma: fundo Surface/light, raios 27/62,
/// linhas 47px, teclas brancas, SF Compact).
class AppNumericKeypad extends StatelessWidget {
  const AppNumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.topAccessory,
  });

  final KeypadDigitCallback onDigit;
  final KeypadBackspaceCallback onBackspace;

  /// Faixa acima das teclas (ex.: sugestão de código SMS no Android).
  final Widget? topAccessory;

  static const List<String?> _row4 = [null, '0', 'back'];

  static const double _rowGapFigma = 8;
  /// Inset lateral do bloco do teclado (Figma ~8).
  static const double _containerPadHFigma = 8;
  /// Espaço entre colunas de teclas (Figma ~6).
  static const double _columnGapFigma = 6;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(DSSize.width(27)),
      topRight: Radius.circular(DSSize.width(27)),
      bottomLeft: Radius.circular(DSSize.width(62)),
      bottomRight: Radius.circular(DSSize.width(62)),
    );

    final rowGap = DSSize.height(_rowGapFigma);
    final containerHPad = DSSize.width(_containerPadHFigma);
    final vPadTop = DSSize.height(24);
    final vPadBottom = DSSize.height(34);

    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: AppPalette.surfaceLight,
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              containerHPad,
              vPadTop,
              containerHPad,
              vPadBottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (topAccessory != null) ...[
                  topAccessory!,
                  SizedBox(height: DSSize.height(12)),
                ],
                _row(context, ['1', '2', '3']),
                SizedBox(height: rowGap),
                _row(context, ['4', '5', '6']),
                SizedBox(height: rowGap),
                _row(context, ['7', '8', '9']),
                SizedBox(height: rowGap),
                _row(context, _row4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, List<String?> keys) {
    return Row(
      children: keys.map((k) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DSSize.width(_columnGapFigma),
            ),
            child: _KeyCell(
              keyId: k,
              onDigit: onDigit,
              onBackspace: onBackspace,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyCell extends StatelessWidget {
  const _KeyCell({
    required this.keyId,
    required this.onDigit,
    required this.onBackspace,
  });

  final String? keyId;
  final KeypadDigitCallback onDigit;
  final KeypadBackspaceCallback onBackspace;

  static const Map<String, String> _letters = {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
  };

  static double get _rowHeight => DSSize.height(47);

  static double get _keyRadius => DSSize.width(8);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final keyText = context.appColors.keyboardNumberText;

    if (keyId == null) {
      return SizedBox(height: _rowHeight);
    }
    if (keyId == 'back') {
      return _keyShell(
        color: Colors.transparent,
        onTap: onBackspace,
        child: Icon(
          Icons.backspace_outlined,
          size: DSSize.width(24),
          color: cs.onSurface.withValues(alpha: 0.75),
        ),
      );
    }

    final d = keyId!;
    final letters = _letters[d];
    final digitStyle = _keypadDigitStyle(keyText);
    final lettersStyle = _keypadLettersStyle(keyText);

    return _keyShell(
      color: AppPalette.surfaceDefault,
      onTap: () => onDigit(d),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(d, style: digitStyle, textAlign: TextAlign.center),
          if (letters != null)
            Text(
              letters,
              style: lettersStyle,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _keyShell({
    required Color color,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(_keyRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _rowHeight,
          width: double.infinity,
          child: Center(child: child),
        ),
      ),
    );
  }
}
