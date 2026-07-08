class StorageKeys {
  StorageKeys._();

  static const locale = 'locale';
  static const onboardingComplete = 'onboarding_complete';
  static const guestMode = 'guest_mode';

  /// In-progress phone OTP challenge (verificationId + metadata).
  static const pendingOtpSession = 'pending_otp_session';

  /// Draft registration fields held until OTP is confirmed.
  static const pendingRegister = 'pending_register';
  static const pendingRegisterPassword = 'pending_register_password';

  /// Lightweight cache of the last authenticated profile for User Settings.
  static const cachedUserProfile = 'cached_user_profile';

  /// Local-only authenticated session used by fake OTP in development.
  static const localAuthSession = 'local_auth_session';
  static const localAuthPassword = 'local_auth_password';
}
