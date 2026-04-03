/// Valida os 11 dígitos de um CPF brasileiro (inclui dígitos verificadores).
bool isValidBrazilianCpfDigits(String digits) {
  if (digits.length != 11 || !RegExp(r'^\d{11}$').hasMatch(digits)) {
    return false;
  }
  if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) return false;

  var sum = 0;
  for (var i = 0; i < 9; i++) {
    sum += int.parse(digits[i]) * (10 - i);
  }
  var d1 = (sum * 10) % 11;
  if (d1 == 10) d1 = 0;
  if (d1 != int.parse(digits[9])) return false;

  sum = 0;
  for (var i = 0; i < 10; i++) {
    sum += int.parse(digits[i]) * (11 - i);
  }
  var d2 = (sum * 10) % 11;
  if (d2 == 10) d2 = 0;
  return d2 == int.parse(digits[10]);
}
