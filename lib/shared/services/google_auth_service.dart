import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

class GoogleAuthService {
  GoogleAuthService(this._auth);

  final FirebaseAuth _auth;

  Future<UserCredential> signIn() async {
    if (kIsWeb) {
      throw UnsupportedError('Configure Google Sign-In for web separately.');
    }

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw StateError('Google sign-in cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }
}

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService(ref.watch(firebaseAuthProvider));
});
