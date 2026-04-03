/// Validação simples de formato de e-mail (sem depender de pacotes).
bool isValidEmailFormat(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty) return false;
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed);
}
