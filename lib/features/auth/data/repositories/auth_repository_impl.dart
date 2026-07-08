import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:pet_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_app/shared/models/user_model.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, {LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService();

  final AuthFirebaseDataSource _dataSource;
  final LocalStorageService _storage;

  @override
  Stream<User?> authStateChanges() => _dataSource.authStateChanges();

  @override
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _dataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String city,
  }) {
    return _dataSource.registerWithEmail(
      email: email,
      password: password,
      username: username,
      phone: phone,
      city: city,
    );
  }

  @override
  Future<void> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> signOut() async {
    await _storage.clearGuestMode();
    await _dataSource.signOut();
  }

  @override
  Future<void> enableGuestMode() async {
    await _storage.setGuestMode(true);
  }

  @override
  Future<UserModel?> getUserProfile(String uid) {
    return _dataSource.getUserProfile(uid);
  }

  @override
  Future<void> updateUserProfile(UserModel user) {
    return _dataSource.updateUserProfile(user);
  }

  @override
  Future<void> saveUserProfile(UserModel user) {
    return _dataSource.saveUserProfile(user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _dataSource.sendPasswordResetEmail(email);
  }
}
