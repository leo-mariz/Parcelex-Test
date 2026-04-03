import 'package:app/core/errors/exceptions.dart' show ServerException;
import 'package:app/core/utils/phone_e164_utils.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Região deployada da callable `checkCpfExists` (Gen 2).
const String kAuthFunctionsRegion = 'southamerica-east1';

/// Resposta da callable [AuthFunctionsService.checkCpfExists].
class CheckCpfExistsResult {
  const CheckCpfExistsResult({
    required this.exists,
    this.phoneNumber,
  });

  final bool exists;

  /// Preenchido quando [exists] é `true` e o Firestore tem telefone; senão `null`.
  final String? phoneNumber;
}

/// Chamadas HTTPS Callable do Firebase (autenticação / onboarding).
abstract class AuthFunctionsService {
  Future<CheckCpfExistsResult> checkCpfExists(String cpf);
}

class FirebaseAuthFunctionsService implements AuthFunctionsService {
  FirebaseAuthFunctionsService([FirebaseFunctions? functions])
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: kAuthFunctionsRegion);

  final FirebaseFunctions _functions;

  @override
  Future<CheckCpfExistsResult> checkCpfExists(String cpf) async {
    final callable = _functions.httpsCallable('checkCpfExists');
    final result = await callable.call(<String, dynamic>{'cpf': cpf});

    final raw = result.data;
    if (raw is! Map) {
      throw ServerException(
        'Resposta inválida de checkCpfExists.',
        originalError: raw,
      );
    }

    final data = Map<String, dynamic>.from(raw);
    final exists = data['exists'];
    if (exists is! bool) {
      throw ServerException(
        'Campo "exists" ausente ou inválido em checkCpfExists.',
        originalError: data,
      );
    }

    final phoneRaw = data['phoneNumber'];
    String? phone;
    if (phoneRaw is String && phoneRaw.trim().isNotEmpty) {
      final e164 = brazilPhoneDigitsToE164(phoneRaw);
      phone = e164.isEmpty ? null : e164;
    }

    return CheckCpfExistsResult(
      exists: exists,
      phoneNumber: phone,
    );
  }
}
