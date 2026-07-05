import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/shared/models/user_model.dart';

class AuthFirebaseDataSource {
  AuthFirebaseDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String city,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    await _users.doc(uid).set({
      'username': username,
      'phone': phone,
      'city': city,
      'role': UserRole.petOwner.value,
      'verified': false,
      'suspended': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> signInWithGoogle() async {
    // GoogleSignIn integration — wire in Phase 1 once OAuth client IDs are configured.
    throw UnimplementedError('Google Sign-In requires platform configuration.');
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, uid: uid);
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
