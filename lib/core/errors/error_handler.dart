import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/core/errors/failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure mapException(Object error) {
    if (error is FirebaseAuthException) {
      return AuthFailure(_mapFirebaseAuthMessage(error.code));
    }
    if (error is Failure) {
      return error;
    }
    if (error is StateError) {
      final message = error.message;
      if (message.isNotEmpty) return AuthFailure(message);
    }
    return ServerFailure(error.toString());
  }

  static String _mapFirebaseAuthMessage(String code) {
    return switch (code) {
      'invalid-credential' || 'wrong-password' => 'Invalid phone or password.',
      'user-not-found' => 'No account found for this phone number.',
      'email-already-in-use' => 'An account already exists.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'invalid-verification-code' => 'Invalid or expired verification code.',
      _ => 'Authentication error ($code).',
    };
  }
}
