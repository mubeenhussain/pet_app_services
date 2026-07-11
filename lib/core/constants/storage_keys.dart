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

  /// OTP rate-limit attempts keyed per E.164 phone.
  static const otpRateLimitPrefix = 'otp_rate_limit_';

  /// Local welcome banner for offline/dev sessions.
  static const welcomeShownPrefix = 'welcome_shown_';
  static const pendingWelcomeTitle = 'pending_welcome_title';
  static const pendingWelcomeBody = 'pending_welcome_body';
}
