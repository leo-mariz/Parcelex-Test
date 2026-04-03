import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

/// Resultado de [AuthService.signInWithSms].
///
/// No Android, a verificação automática pode concluir o login sem digitar o código;
/// nesse caso use [userCredential] e não chame [AuthService.verifySmsOtp].
class SmsSignInChallenge {
  SmsSignInChallenge.requiresCode({
    required this.verificationId,
    this.forceResendingToken,
  }) : userCredential = null;

  SmsSignInChallenge.alreadySignedIn({required this.userCredential})
      : verificationId = null,
        forceResendingToken = null;

  final String? verificationId;
  final int? forceResendingToken;
  final UserCredential? userCredential;

  bool get needsManualOtp =>
      userCredential == null && verificationId != null && verificationId!.isNotEmpty;
}

/// Contrato de autenticação Firebase para login e onboarding (OTP por SMS).
abstract class AuthService {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<void> signOut();

  /// Dispara o SMS com o código. Guarde [SmsSignInChallenge.verificationId] para [verifySmsOtp].
  ///
  /// [phoneNumber] no formato E.164 (ex.: `+5511999998888`).
  /// [forceResendingToken] veio do envio anterior, para reenvio.
  Future<SmsSignInChallenge> signInWithSms(
    String phoneNumber, {
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  });

  /// Confirma o código recebido por SMS e conclui o login.
  Future<UserCredential> verifySmsOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<String?> getIdToken({bool forceRefresh = false});

  Future<void> reloadCurrentUser();
}

/// Implementação com [FirebaseAuth].
class FirebaseAuthService implements AuthService {
  FirebaseAuthService([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<SmsSignInChallenge> signInWithSms(
    String phoneNumber, {
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final completer = Completer<SmsSignInChallenge>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (completer.isCompleted) return;
        try {
          final cred = await _auth.signInWithCredential(credential);
          completer.complete(SmsSignInChallenge.alreadySignedIn(userCredential: cred));
        } catch (e, st) {
          completer.completeError(e, st);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(
            SmsSignInChallenge.requiresCode(
              verificationId: verificationId,
              forceResendingToken: resendToken,
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(
            SmsSignInChallenge.requiresCode(verificationId: verificationId),
          );
        }
      },
    );

    return completer.future;
  }

  @override
  Future<UserCredential> verifySmsOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }

  @override
  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }
}
