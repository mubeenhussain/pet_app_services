class AppConstants {
  AppConstants._();

  static const appName = 'Pet Services';
  static const minPasswordLength = 8;
  static const minUsernameLength = 3;
  static const maxUsernameLength = 30;
  static const otpLength = 6;
  /// Development-only OTP when Firebase Phone Auth is not configured.
  static const fakeOtpCode = '123456';
  static const fakeOtpVerificationId = 'fake_otp_verification';
  static const maxOtpRequestsPerWindow = 3;
  static const otpRateLimitMinutes = 10;
  static const rescuePinMaxDescriptionLength = 200;
  static const defaultRescuePinExpiryHours = 72;
  static const defaultCurrency = 'SAR';
  static const maxContentWidth = 420.0;
  static const authContentWidth = 344.0;
  static const authHorizontalPadding = 16.0;
}
