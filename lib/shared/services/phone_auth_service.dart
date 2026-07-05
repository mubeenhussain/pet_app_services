import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

class PhoneAuthSession {
  const PhoneAuthSession({
    required this.verificationId,
    this.resendToken,
  });

  final String verificationId;
  final int? resendToken;
}

class PhoneAuthService {
  PhoneAuthService(this._auth);

  final FirebaseAuth _auth;

  Future<PhoneAuthSession> sendOtp({
    required String phoneE164,
    int? forceResendingToken,
  }) async {
    final completer = Completer<PhoneAuthSession>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      forceResendingToken: forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        if (!completer.isCompleted) {
          await _auth.signInWithCredential(credential);
          completer.completeError(
            StateError('Auto-verified — user signed in directly.'),
          );
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (verificationId, resendToken) {
        if (!completer.isCompleted) {
          completer.complete(
            PhoneAuthSession(
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Normalizes Saudi numbers to E.164 when user omits country code.
  static String normalizePhone(String raw) {
    var phone = raw.replaceAll(RegExp(r'\s+'), '');
    if (phone.startsWith('00')) phone = '+${phone.substring(2)}';
    if (!phone.startsWith('+')) {
      if (phone.startsWith('0')) phone = phone.substring(1);
      phone = '+966$phone';
    }
    return phone;
  }
}

final phoneAuthServiceProvider = Provider<PhoneAuthService>((ref) {
  return PhoneAuthService(ref.watch(firebaseAuthProvider));
});

final phoneAuthSessionProvider = StateProvider<PhoneAuthSession?>((ref) => null);
