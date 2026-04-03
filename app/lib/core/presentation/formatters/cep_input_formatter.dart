import 'package:flutter/services.dart';

/// Máscara CEP `00000-000` (8 dígitos).
class CepInputFormatter extends TextInputFormatter {
  const CepInputFormatter();

  static const int maxDigits = 8;

  static final RegExp _nonDigit = RegExp(r'\D');

  static String digitsOnly(String text) => text.replaceAll(_nonDigit, '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(_nonDigit, '');
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    final formatted = _format(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _format(String digits) {
    if (digits.length <= 5) return digits;
    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }
}
