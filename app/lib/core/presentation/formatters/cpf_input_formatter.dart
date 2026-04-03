import 'package:flutter/services.dart';

/// Máscara `000.000.000-00` durante a digitação (máx. 11 dígitos).
class CpfInputFormatter extends TextInputFormatter {
  const CpfInputFormatter();

  static const int maxDigits = 11;

  static final RegExp _nonDigit = RegExp(r'\D');

  /// Apenas os 11 dígitos, para validação/envio.
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
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buf.write('.');
      if (i == 9) buf.write('-');
      buf.write(digits[i]);
    }
    return buf.toString();
  }
}
