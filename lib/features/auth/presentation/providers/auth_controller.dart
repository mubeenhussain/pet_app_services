import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/errors/error_handler.dart';
import 'package:pet_app/core/utils/auth_credentials.dart';
import 'package:pet_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/guest_mode_provider.dart';
import 'package:pet_app/shared/services/google_auth_service.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
    ref.watch(localStorageProvider),
    ref.watch(phoneAuthServiceProvider),
    ref.watch(googleAuthServiceProvider),
  );
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(
    this._repository,
    this._ref,
    this._storage,
    this._phoneAuth,
    this._googleAuth,
  ) : super(const AsyncData(null));

  final AuthRepository _repository;
  final Ref _ref;
  final LocalStorageService _storage;
  final PhoneAuthService _phoneAuth;
  final GoogleAuthService _googleAuth;

  Future<void> _clearGuest() async {
    await _storage.clearGuestMode();
    _ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      await _repository.signInWithEmail(
        AuthCredentials.phoneToEmail(phone),
        password,
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      await _repository.signInWithEmail(email, password);
    });
  }

  Future<void> sendRegisterOtp(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final normalized = PhoneAuthService.normalizePhone(phone);
      final session = await _phoneAuth.sendOtp(phoneE164: normalized);
      _ref.read(phoneAuthSessionProvider.notifier).state = session;
    });
  }

  Future<void> registerWithPhone({
    required String phone,
    required String password,
    required String username,
    required String city,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      await _repository.registerWithEmail(
        email: AuthCredentials.phoneToEmail(phone),
        password: password,
        username: username,
        phone: PhoneAuthService.normalizePhone(phone),
        city: city,
      );
    });
  }

  Future<void> confirmPhoneOtp(String smsCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = _ref.read(phoneAuthSessionProvider);
      if (session == null) {
        throw StateError('OTP session expired. Resend code.');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: session.verificationId,
        smsCode: smsCode,
      );

      final user = _ref.read(firebaseAuthProvider).currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);
      } else {
        await _ref.read(firebaseAuthProvider).signInWithCredential(credential);
      }
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String city,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.registerWithEmail(
        email: email,
        password: password,
        username: username,
        phone: phone,
        city: city,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      await _googleAuth.signIn();
    });
  }

  Future<void> skipAsGuest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.enableGuestMode();
      _ref.read(guestModeProvider.notifier).state = true;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signOut);
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.sendPasswordResetEmail(email));
  }

  Future<void> sendResetOtp(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await _phoneAuth.sendOtp(
        phoneE164: PhoneAuthService.normalizePhone(phone),
      );
      _ref.read(phoneAuthSessionProvider.notifier).state = session;
    });
  }

  String? mapError(Object error) => ErrorHandler.mapException(error).message;
}
