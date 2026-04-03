import 'dart:math' as math;

import 'package:flutter/services.dart';

/// Máscara `(00) 00000-0000` (11 dígitos) ou `(00) 0000-0000` (10 dígitos).
class BrazilianPhoneInputFormatter extends TextInputFormatter {
  const BrazilianPhoneInputFormatter();

  static final RegExp _nonDigit = RegExp(r'\D');

  static String digitsOnly(String text) => text.replaceAll(_nonDigit, '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(_nonDigit, '');
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    final formatted = _format(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _format(String digits) {
    if (digits.isEmpty) return '';
    final buf = StringBuffer('(');
    buf.write(digits.substring(0, math.min(2, digits.length)));
    if (digits.length < 2) return buf.toString();
    buf.write(') ');
    final rest = digits.substring(2);
    if (rest.isEmpty) return buf.toString();
    final firstBlock = digits.length > 10 ? 5 : 4;
    if (rest.length <= firstBlock) {
      buf.write(rest);
    } else {
      buf.write(rest.substring(0, firstBlock));
      buf.write('-');
      buf.write(rest.substring(firstBlock));
    }
    return buf.toString();
  }
}
