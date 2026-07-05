import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/shared/models/user_model.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String city,
  });
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> enableGuestMode();
  Future<UserModel?> getUserProfile(String uid);
  Future<void> updateUserProfile(UserModel user);
  Future<void> sendPasswordResetEmail(String email);
}
