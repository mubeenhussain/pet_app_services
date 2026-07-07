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
  String get skipForNow => 'Skip for now';

  @override
  String get registerTitle => 'Create account';

  @override
  String get usernameHint => 'Username';

  @override
  String get cityHint => 'City';

  @override
  String get submit => 'Submit';

  @override
  String get otpTitle => 'Verify phone';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the code sent to $phone';
  }

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
