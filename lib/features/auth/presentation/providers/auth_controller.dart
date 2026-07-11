import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/config/app_config.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/core/errors/error_handler.dart';
import 'package:pet_app/core/utils/auth_credentials.dart';
import 'package:pet_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/shared/models/user_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/guest_mode_provider.dart';
import 'package:pet_app/shared/services/google_auth_service.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/services/otp_rate_limit_service.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';
import 'package:pet_app/shared/services/welcome_notification_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
    ref.watch(localStorageProvider),
    ref.watch(phoneAuthServiceProvider),
    ref.watch(googleAuthServiceProvider),
    ref.watch(otpRateLimitServiceProvider),
    ref.watch(welcomeNotificationServiceProvider),
  );
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(
    this._repository,
    this._ref,
    this._storage,
    this._phoneAuth,
    this._googleAuth,
    this._otpRateLimit,
    this._welcomeNotifications,
  ) : super(const AsyncData(null));

  final AuthRepository _repository;
  final Ref _ref;
  final LocalStorageService _storage;
  final PhoneAuthService _phoneAuth;
  final GoogleAuthService _googleAuth;
  final OtpRateLimitService _otpRateLimit;
  final WelcomeNotificationService _welcomeNotifications;

  Future<void> _clearGuest() async {
    await _storage.clearGuestMode();
    _ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> _cacheProfile(UserModel user) async {
    await _storage.saveCachedUserProfile(
      CachedUserProfile(
        uid: user.uid,
        username: user.username,
        phone: user.phone,
        email: user.email,
        city: user.city,
        createdAtYear: user.createdAt?.year,
      ),
    );
    _ref.invalidate(cachedUserProfileProvider);
    _ref.invalidate(authStateProvider);
  }

  Future<void> _persistAuthUser(String uid) async {
    final profile = await _repository.getUserProfile(uid);
    if (profile != null) {
      await _cacheProfile(profile);
    }
  }

  Future<void> _ensureWelcomeNotification({
    required String uid,
    required String username,
  }) async {
    await _welcomeNotifications.ensureWelcome(
      uid: uid,
      title: 'Welcome to Pet Services!',
      body: 'Your account is ready. Explore services, buy pets, and book rides.',
    );
  }

  Future<void> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();

      // Dev / no-Firebase: authenticate against locally saved register data.
      if (AppConfig.instance.useFakeOtp) {
        final local = await _storage.readLocalAuthSession();
        final localPassword = await _storage.readLocalAuthPassword();
        final normalized = PhoneAuthService.normalizePhone(phone);

        if (local != null &&
            local.phone == normalized &&
            localPassword == password) {
          await _cacheProfile(
            UserModel(
              uid: local.uid,
              username: local.username,
              phone: local.phone,
              email: local.email,
              city: local.city,
              role: UserRole.petOwner,
              createdAt: local.createdAtYear == null
                  ? null
                  : DateTime(local.createdAtYear!),
            ),
          );
          return;
        }
      }

      try {
        final credential = await _repository.signInWithEmail(
          AuthCredentials.phoneToEmail(phone),
          password,
        );
        final uid = credential.user?.uid;
        if (uid != null) {
          await _persistAuthUser(uid);
        }
      } catch (e) {
        // Last resort for local fake sessions with mismatched firebase setup.
        final local = await _storage.readLocalAuthSession();
        final localPassword = await _storage.readLocalAuthPassword();
        final normalized = PhoneAuthService.normalizePhone(phone);
        if (local != null &&
            local.phone == normalized &&
            localPassword == password) {
          await _cacheProfile(
            UserModel(
              uid: local.uid,
              username: local.username,
              phone: local.phone,
              email: local.email,
              city: local.city,
              role: UserRole.petOwner,
              createdAt: local.createdAtYear == null
                  ? null
                  : DateTime(local.createdAtYear!),
            ),
          );
          return;
        }
        rethrow;
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      final credential = await _repository.signInWithEmail(email, password);
      final uid = credential.user?.uid;
      if (uid != null) await _persistAuthUser(uid);
    });
  }

  Future<void> _completeAuthentication(UserModel user) async {
    await _cacheProfile(user);
    await _ensureWelcomeNotification(uid: user.uid, username: user.username);
  }

  Future<void> sendRegisterOtp(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final normalized = PhoneAuthService.normalizePhone(phone);

      // Dev shortcut: no Firebase Phone Auth required.
      if (AppConfig.instance.useFakeOtp) {
        final session = const PhoneAuthSession(
          verificationId: AppConstants.fakeOtpVerificationId,
        );
        _ref.read(phoneAuthSessionProvider.notifier).state = session;
        await _storage.savePendingOtpSession(
          session: session,
          phone: normalized,
          flow: 'register',
        );
        return;
      }

      await _otpRateLimit.assertCanRequest(normalized);
      final session = await _phoneAuth.sendOtp(phoneE164: normalized);
      await _otpRateLimit.recordRequest(normalized);
      _ref.read(phoneAuthSessionProvider.notifier).state = session;
      await _storage.savePendingOtpSession(
        session: session,
        phone: normalized,
        flow: 'register',
      );
    });
  }

  Future<void> savePendingRegistration({
    required String username,
    required String phone,
    required String password,
    required String city,
  }) {
    return _storage.savePendingRegister(
      PendingRegisterDraft(
        username: username.trim(),
        phone: PhoneAuthService.normalizePhone(phone),
        password: password,
        city: city.trim(),
      ),
    );
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
      final credential = await _repository.registerWithEmail(
        email: AuthCredentials.phoneToEmail(phone),
        password: password,
        username: username,
        phone: PhoneAuthService.normalizePhone(phone),
        city: city,
      );
      final uid = credential.user?.uid;
      if (uid != null) await _persistAuthUser(uid);
    });
  }

  Future<PhoneAuthSession?> _resolveOtpSession({String? phone}) async {
    final memory = _ref.read(phoneAuthSessionProvider);
    if (memory != null) return memory;

    final stored = await _storage.readPendingOtpSession();
    if (stored != null) {
      _ref.read(phoneAuthSessionProvider.notifier).state = stored.session;
      return stored.session;
    }

    // Debug/dev: recreate a fake session so Confirm never dies on hot restart.
    if (AppConfig.instance.useFakeOtp) {
      final session = const PhoneAuthSession(
        verificationId: AppConstants.fakeOtpVerificationId,
      );
      _ref.read(phoneAuthSessionProvider.notifier).state = session;
      final draft = await _storage.readPendingRegister();
      await _storage.savePendingOtpSession(
        session: session,
        phone: phone ?? draft?.phone ?? '',
        flow: 'register',
      );
      return session;
    }

    return null;
  }

  Future<void> confirmPhoneOtp(String smsCode, {String? phone}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await _resolveOtpSession(phone: phone);
      if (session == null) {
        throw StateError('OTP session expired. Resend code.');
      }

      final isFakeSession =
          session.verificationId == AppConstants.fakeOtpVerificationId ||
              AppConfig.instance.useFakeOtp;

      if (isFakeSession) {
        if (smsCode.trim() != AppConstants.fakeOtpCode) {
          throw StateError(
            'Invalid code. Use ${AppConstants.fakeOtpCode} in development.',
          );
        }

        final draft = await _storage.readPendingRegister();
        if (draft == null) {
          throw StateError('Registration draft missing. Start register again.');
        }

        await _clearGuest();
        final email = AuthCredentials.phoneToEmail(draft.phone);
        final now = DateTime.now();

        // Prefer Firebase Auth when available; fall back to local session.
        try {
          final credential = await _repository.registerWithEmail(
            email: email,
            password: draft.password,
            username: draft.username,
            phone: draft.phone,
            city: draft.city,
          );
          final uid = credential.user?.uid;
          if (uid != null) {
            final profile = await _repository.getUserProfile(uid);
            if (profile != null) {
              await _completeAuthentication(profile);
            }
          }
        } catch (_) {
          final localProfile = CachedUserProfile(
            uid: 'local_${draft.phone}',
            username: draft.username,
            phone: draft.phone,
            email: email,
            city: draft.city,
            createdAtYear: now.year,
          );
          await _storage.saveLocalAuthSession(
            localProfile,
            password: draft.password,
          );
          await _completeAuthentication(
            UserModel(
              uid: localProfile.uid,
              username: localProfile.username,
              phone: localProfile.phone,
              email: localProfile.email,
              city: localProfile.city,
              role: UserRole.petOwner,
              createdAt: now,
            ),
          );
        }

        await _storage.clearPendingRegister();
        await _storage.clearPendingOtpSession();
        _ref.read(phoneAuthSessionProvider.notifier).state = null;
        return;
      }

      final phoneCredential = PhoneAuthProvider.credential(
        verificationId: session.verificationId,
        smsCode: smsCode,
      );

      final auth = _ref.read(firebaseAuthProvider);
      final draft = await _storage.readPendingRegister();

      if (draft != null) {
        await _clearGuest();

        // 1) Verify OTP and start authenticated session.
        final phoneSignIn = await auth.signInWithCredential(phoneCredential);
        final user = phoneSignIn.user;
        if (user == null) {
          throw StateError('Phone verification failed. Try again.');
        }

        // 2) Attach email+password so future logins work with phone/password.
        final emailCredential = EmailAuthProvider.credential(
          email: AuthCredentials.phoneToEmail(draft.phone),
          password: draft.password,
        );
        try {
          await user.linkWithCredential(emailCredential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use' ||
              e.code == 'email-already-in-use') {
            throw StateError(
              'This phone is already registered. Please sign in.',
            );
          }
          rethrow;
        }

        // 3) Persist profile document used by User Settings + local cache.
        final profile = UserModel(
          uid: user.uid,
          username: draft.username,
          phone: draft.phone,
          email: AuthCredentials.phoneToEmail(draft.phone),
          city: draft.city,
          role: UserRole.petOwner,
          createdAt: DateTime.now(),
        );
        await _repository.saveUserProfile(profile);
        await _completeAuthentication(profile);
        await _storage.clearPendingRegister();
      } else {
        final currentUser = auth.currentUser;
        if (currentUser != null) {
          await currentUser.linkWithCredential(phoneCredential);
        } else {
          await auth.signInWithCredential(phoneCredential);
        }
      }

      await _storage.clearPendingOtpSession();
      _ref.read(phoneAuthSessionProvider.notifier).state = null;
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
      final credential = await _repository.registerWithEmail(
        email: email,
        password: password,
        username: username,
        phone: phone,
        city: city,
      );
      final uid = credential.user?.uid;
      if (uid != null) await _persistAuthUser(uid);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _clearGuest();
      final credential = await _googleAuth.signIn();
      final user = credential.user;
      if (user == null) {
        throw StateError('Google sign-in failed. Try again.');
      }

      var profile = await _repository.getUserProfile(user.uid);
      if (profile == null) {
        profile = UserModel(
          uid: user.uid,
          username: user.displayName?.trim().isNotEmpty == true
              ? user.displayName!.trim()
              : 'user',
          phone: user.phoneNumber ?? '',
          email: user.email,
          role: UserRole.petOwner,
          createdAt: DateTime.now(),
        );
        await _repository.saveUserProfile(profile);
      }

      await _completeAuthentication(profile);
    });
  }

  Future<void> skipAsGuest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.enableGuestMode();
      _ref.read(guestModeProvider.notifier).state = true;
      await _storage.clearCachedUserProfile();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signOut();
      _ref.read(guestModeProvider.notifier).state = false;
      await _storage.clearCachedUserProfile();
      await _storage.clearLocalAuthSession();
      await _storage.clearPendingOtpSession();
      await _storage.clearPendingRegister();
      _ref.read(phoneAuthSessionProvider.notifier).state = null;
    });
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _repository.sendPasswordResetEmail(email));
  }

  Future<void> sendResetOtp(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final normalized = PhoneAuthService.normalizePhone(phone);

      if (AppConfig.instance.useFakeOtp) {
        final session = const PhoneAuthSession(
          verificationId: AppConstants.fakeOtpVerificationId,
        );
        _ref.read(phoneAuthSessionProvider.notifier).state = session;
        await _storage.savePendingOtpSession(
          session: session,
          phone: normalized,
          flow: 'reset',
        );
        return;
      }

      await _otpRateLimit.assertCanRequest(normalized);
      final session = await _phoneAuth.sendOtp(phoneE164: normalized);
      await _otpRateLimit.recordRequest(normalized);
      _ref.read(phoneAuthSessionProvider.notifier).state = session;
      await _storage.savePendingOtpSession(
        session: session,
        phone: normalized,
        flow: 'reset',
      );
    });
  }

  String? mapError(Object error) {
    if (error is OtpRateLimitException) {
      return 'Too many OTP requests. Try again in ${error.retryAfterMinutes} minutes.';
    }
    return ErrorHandler.mapException(error).message;
  }
}
