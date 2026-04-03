/// Normaliza dígitos de telefone brasileiro para E.164 (`+55...`).
String brazilPhoneDigitsToE164(String digitsOnly) {
  final d = digitsOnly.replaceAll(RegExp(r'\D'), '');
  if (d.isEmpty) return '';
  var body = d;
  if (body.startsWith('0')) {
    body = body.substring(1);
  }
  if (body.startsWith('55') && body.length >= 12) {
    return '+$body';
  }
  return '+55$body';
}
