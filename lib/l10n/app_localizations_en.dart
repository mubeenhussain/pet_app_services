// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pet Services';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to keep caring for your pets';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get phoneHint => 'Phone number';

  @override
  String get passwordHint => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your phone number and we\'ll send you a code to reset it';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetCodeSent => 'Reset code sent';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get setPasswordTitle => 'Set new password';

  @override
  String get setPasswordSubtitle =>
      'Create a strong password to secure your account';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthGood => 'Good';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Join PawBuddy and start your pet\'s journey';

  @override
  String get usernameHint => 'Username';

  @override
  String get usernameExample => 'e.g. sara_khan';

  @override
  String get phoneExample => '300 1234567';

  @override
  String get passwordMinHint => 'Min. 8 characters';

  @override
  String get passwordHelper => 'Minimum 8 characters';

  @override
  String get cityAddressLabel => 'City / Address';

  @override
  String get selectCity => 'Select your city';

  @override
  String get optional => 'optional';

  @override
  String get agreeToTerms => 'I agree to';

  @override
  String get termsAndPrivacy => 'Terms & Privacy Policy';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get mustAcceptTerms => 'Please accept the terms to continue';

  @override
  String get cityHint => 'City';

  @override
  String get submit => 'Submit';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the code sent to $phone';
  }

  @override
  String otpInstruction(int length) {
    return 'Enter the $length-digit code sent to';
  }

  @override
  String otpInvalid(int length) {
    return 'Enter the $length-digit code';
  }

  @override
  String get otpResent => 'Code resent';

  @override
  String get didntGetCode => 'Didn\'t get the code?';

  @override
  String resendIn(String time) {
    return 'Resend in $time';
  }

  @override
  String get resend => 'Resend';

  @override
  String get confirm => 'Confirm';

  @override
  String get resendOtp => 'Resend code';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get yourPets => 'Your Pets';

  @override
  String get orders => 'Orders';

  @override
  String get accountType => 'Account Type';

  @override
  String get userSettings => 'User Settings';

  @override
  String get addPet => 'Add Pet';

  @override
  String get noPetsYet => 'No pets yet — add one';

  @override
  String get petName => 'Pet name';

  @override
  String get species => 'Species';

  @override
  String get breed => 'Breed';

  @override
  String get age => 'Age';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueLabel => 'Continue';

  @override
  String get requestRide => 'Request Pet Delivery';

  @override
  String get pickup => 'Pickup location';

  @override
  String get destination => 'Destination';

  @override
  String get selectPet => 'Select pet';

  @override
  String get checkout => 'Checkout';

  @override
  String get confirmAndPay => 'Confirm & Pay';

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get tryAgain => 'Try again';

  @override
  String get loading => 'Loading...';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get verificationPending => 'Verification pending';

  @override
  String get documentUpload => 'Upload documents';

  @override
  String get searchingForDriver => 'Searching for a driver...';

  @override
  String get driverAllocated => 'Driver allocated';

  @override
  String get deliveryConfirmed => 'Delivery confirmed';

  @override
  String get logout => 'Log out';

  @override
  String get guestUser => 'Guest';

  @override
  String get guestProfileMessage =>
      'You are browsing as a guest. Sign in to save your profile and pets.';
}
