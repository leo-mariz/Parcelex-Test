/// Mascara e-mail para exibição (ex.: `l***14@gmail.com`).
String maskEmailForDisplay(String email) {
  final e = email.trim();
  final at = e.indexOf('@');
  if (at < 1) return e.isEmpty ? '***' : e;
  final local = e.substring(0, at);
  final domain = e.substring(at);
  if (local.length <= 1) {
    return '$local***$domain';
  }
  final first = local[0];
  final tailStart = local.length >= 3 ? local.length - 2 : 1;
  final tail = local.substring(tailStart);
  return '$first***$tail$domain';
}
