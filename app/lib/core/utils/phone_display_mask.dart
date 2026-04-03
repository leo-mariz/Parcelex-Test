/// Máscara simples para exibir telefone (E.164 ou dígitos) na UI de OTP.
String maskPhoneForOtpDisplay(String phoneE164OrDigits) {
  final d = phoneE164OrDigits.replaceAll(RegExp(r'\D'), '');
  if (d.length >= 4) {
    return '(**) *****-${d.substring(d.length - 4)}';
  }
  return '(**) *****-****';
}
