import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet Services'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep caring for your pets'**
  String get loginSubtitle;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you a code to reset it'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @resetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Reset code sent'**
  String get resetCodeSent;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @setPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setPasswordTitle;

  /// No description provided for @setPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password to secure your account'**
  String get setPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @strengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get strengthWeak;

  /// No description provided for @strengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get strengthFair;

  /// No description provided for @strengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get strengthGood;

  /// No description provided for @strengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strengthStrong;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join PawBuddy and start your pet\'s journey'**
  String get registerSubtitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @usernameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. sara_khan'**
  String get usernameExample;

  /// No description provided for @phoneExample.
  ///
  /// In en, this message translates to:
  /// **'300 1234567'**
  String get phoneExample;

  /// No description provided for @passwordMinHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get passwordMinHint;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordHelper;

  /// No description provided for @cityAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Address'**
  String get cityAddressLabel;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectCity;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get agreeToTerms;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @mustAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue'**
  String get mustAcceptTerms;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityHint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the {length}-digit code sent to'**
  String otpInstruction(int length);

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the {length}-digit code'**
  String otpInvalid(int length);

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent'**
  String get otpResent;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get didntGetCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendIn(String time);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @yourPets.
  ///
  /// In en, this message translates to:
  /// **'Your Pets'**
  String get yourPets;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @userSettings.
  ///
  /// In en, this message translates to:
  /// **'User Settings'**
  String get userSettings;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get addPet;

  /// No description provided for @noPetsYet.
  ///
  /// In en, this message translates to:
  /// **'No pets yet — add one'**
  String get noPetsYet;

  /// No description provided for @petName.
  ///
  /// In en, this message translates to:
  /// **'Pet name'**
  String get petName;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @requestRide.
  ///
  /// In en, this message translates to:
  /// **'Request Pet Delivery'**
  String get requestRide;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickup;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @selectPet.
  ///
  /// In en, this message translates to:
  /// **'Select pet'**
  String get selectPet;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @confirmAndPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmAndPay;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification pending'**
  String get verificationPending;

  /// No description provided for @documentUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload documents'**
  String get documentUpload;

  /// No description provided for @searchingForDriver.
  ///
  /// In en, this message translates to:
  /// **'Searching for a driver...'**
  String get searchingForDriver;

  /// No description provided for @driverAllocated.
  ///
  /// In en, this message translates to:
  /// **'Driver allocated'**
  String get driverAllocated;

  /// No description provided for @deliveryConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed'**
  String get deliveryConfirmed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUser;

  /// No description provided for @guestProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'You are browsing as a guest. Sign in to save your profile and pets.'**
  String get guestProfileMessage;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get homeWelcome;

  /// No description provided for @homeServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get homeServices;

  /// No description provided for @homeBuySell.
  ///
  /// In en, this message translates to:
  /// **'Buy & Sell'**
  String get homeBuySell;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeRescueBanner.
  ///
  /// In en, this message translates to:
  /// **'Active rescue nearby — tap to help'**
  String get homeRescueBanner;

  /// No description provided for @homeGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get homeGrooming;

  /// No description provided for @homeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get homeDelivery;

  /// No description provided for @homeBoarding.
  ///
  /// In en, this message translates to:
  /// **'Boarding'**
  String get homeBoarding;

  /// No description provided for @homeShower.
  ///
  /// In en, this message translates to:
  /// **'Shower'**
  String get homeShower;

  /// No description provided for @homeSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get homeSupplies;

  /// No description provided for @homeRescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get homeRescue;

  /// No description provided for @homeRide.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get homeRide;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navRescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get navRescue;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @switchToArabic.
  ///
  /// In en, this message translates to:
  /// **'Switch to Arabic'**
  String get switchToArabic;

  /// No description provided for @switchToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// No description provided for @listingLabradorPup.
  ///
  /// In en, this message translates to:
  /// **'Labrador Pup'**
  String get listingLabradorPup;

  /// No description provided for @listingCockatiel.
  ///
  /// In en, this message translates to:
  /// **'Cockatiel'**
  String get listingCockatiel;

  /// No description provided for @listingArabianHorse.
  ///
  /// In en, this message translates to:
  /// **'Arabian Horse'**
  String get listingArabianHorse;

  /// No description provided for @tabServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get tabServicesTitle;

  /// No description provided for @tabServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse pet services'**
  String get tabServicesSubtitle;

  /// No description provided for @tabRescueTitle.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get tabRescueTitle;

  /// No description provided for @tabRescueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency rescue — coming soon'**
  String get tabRescueSubtitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @applyWithCount.
  ///
  /// In en, this message translates to:
  /// **'Apply ({count} results)'**
  String applyWithCount(int count);

  /// No description provided for @sarAmountFormatted.
  ///
  /// In en, this message translates to:
  /// **'SAR {amount}'**
  String sarAmountFormatted(String amount);

  /// No description provided for @ageYear.
  ///
  /// In en, this message translates to:
  /// **'{count} yr'**
  String ageYear(int count);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{count} yrs'**
  String ageYears(int count);

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String memberSince(int year);

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get labelPhone;

  /// No description provided for @labelCity.
  ///
  /// In en, this message translates to:
  /// **'CITY'**
  String get labelCity;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get labelEmail;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @photoUpdateSoon.
  ///
  /// In en, this message translates to:
  /// **'Photo update coming soon'**
  String get photoUpdateSoon;

  /// No description provided for @tapChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapChangePhoto;

  /// No description provided for @signInToSavePet.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save a pet'**
  String get signInToSavePet;

  /// No description provided for @petSaved.
  ///
  /// In en, this message translates to:
  /// **'Pet saved'**
  String get petSaved;

  /// No description provided for @petUpdated.
  ///
  /// In en, this message translates to:
  /// **'Pet updated'**
  String get petUpdated;

  /// No description provided for @petDeleted.
  ///
  /// In en, this message translates to:
  /// **'Pet deleted'**
  String get petDeleted;

  /// No description provided for @addNewPet.
  ///
  /// In en, this message translates to:
  /// **'Add New Pet'**
  String get addNewPet;

  /// No description provided for @editPet.
  ///
  /// In en, this message translates to:
  /// **'Edit Pet'**
  String get editPet;

  /// No description provided for @savePet.
  ///
  /// In en, this message translates to:
  /// **'Save Pet'**
  String get savePet;

  /// No description provided for @myPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPets;

  /// No description provided for @nameHintBuddy.
  ///
  /// In en, this message translates to:
  /// **'e.g. Buddy'**
  String get nameHintBuddy;

  /// No description provided for @breedHintGoldenRetriever.
  ///
  /// In en, this message translates to:
  /// **'e.g. Golden Retriever'**
  String get breedHintGoldenRetriever;

  /// No description provided for @speciesDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get speciesDog;

  /// No description provided for @speciesCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get speciesCat;

  /// No description provided for @speciesBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get speciesBird;

  /// No description provided for @speciesOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get speciesOther;

  /// No description provided for @photoUploadSoon.
  ///
  /// In en, this message translates to:
  /// **'Photo upload coming soon'**
  String get photoUploadSoon;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @deletePet.
  ///
  /// In en, this message translates to:
  /// **'Delete Pet'**
  String get deletePet;

  /// No description provided for @deletePetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String deletePetConfirm(String name);

  /// No description provided for @petNotFound.
  ///
  /// In en, this message translates to:
  /// **'Pet not found'**
  String get petNotFound;

  /// No description provided for @editPetName.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editPetName(String name);

  /// No description provided for @buyAPet.
  ///
  /// In en, this message translates to:
  /// **'Buy a Pet'**
  String get buyAPet;

  /// No description provided for @searchBreedCity.
  ///
  /// In en, this message translates to:
  /// **'Search breed, city...'**
  String get searchBreedCity;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @providerDetails.
  ///
  /// In en, this message translates to:
  /// **'Provider Details'**
  String get providerDetails;

  /// No description provided for @flagInterestReport.
  ///
  /// In en, this message translates to:
  /// **'Flag Interest / Report'**
  String get flagInterestReport;

  /// No description provided for @askAboutPet.
  ///
  /// In en, this message translates to:
  /// **'Ask About Pet'**
  String get askAboutPet;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @askAbout.
  ///
  /// In en, this message translates to:
  /// **'Ask about {name}'**
  String askAbout(String name);

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'YOUR MESSAGE'**
  String get yourMessage;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @askDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m interested in {name} — is {name} still available?'**
  String askDefaultMessage(String name);

  /// No description provided for @breedPriceLine.
  ///
  /// In en, this message translates to:
  /// **'{breed} · {price}'**
  String breedPriceLine(String breed, String price);

  /// No description provided for @categoryDogs.
  ///
  /// In en, this message translates to:
  /// **'Dogs'**
  String get categoryDogs;

  /// No description provided for @categoryCats.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get categoryCats;

  /// No description provided for @categoryBirds.
  ///
  /// In en, this message translates to:
  /// **'Birds'**
  String get categoryBirds;

  /// No description provided for @categoryHorses.
  ///
  /// In en, this message translates to:
  /// **'Horses'**
  String get categoryHorses;

  /// No description provided for @categoryCamels.
  ///
  /// In en, this message translates to:
  /// **'Camels'**
  String get categoryCamels;

  /// No description provided for @categoryAdoption.
  ///
  /// In en, this message translates to:
  /// **'Adoption'**
  String get categoryAdoption;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @chatSafetyBanner.
  ///
  /// In en, this message translates to:
  /// **'This chat is monitored for safety'**
  String get chatSafetyBanner;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @contactInfoWarning.
  ///
  /// In en, this message translates to:
  /// **'Message contains contact info'**
  String get contactInfoWarning;

  /// No description provided for @demoMsgKittenAvailable.
  ///
  /// In en, this message translates to:
  /// **'Hi! Is the Persian kitten still available?'**
  String get demoMsgKittenAvailable;

  /// No description provided for @demoMsgKittenReply.
  ///
  /// In en, this message translates to:
  /// **'Yes she is! Vaccinated and ready to go 🐱'**
  String get demoMsgKittenReply;

  /// No description provided for @demoMsgKittenConfirm.
  ///
  /// In en, this message translates to:
  /// **'Perfect, thank you! Chat locked once we confirm 🔒'**
  String get demoMsgKittenConfirm;

  /// No description provided for @previewPersianAvailable.
  ///
  /// In en, this message translates to:
  /// **'Is the Persian still avai…'**
  String get previewPersianAvailable;

  /// No description provided for @previewDeliverSaturday.
  ///
  /// In en, this message translates to:
  /// **'We can deliver it Satur…'**
  String get previewDeliverSaturday;

  /// No description provided for @previewThankYouSaturday.
  ///
  /// In en, this message translates to:
  /// **'Thank you! See you S…'**
  String get previewThankYouSaturday;

  /// No description provided for @previewNewArrivalsFriday.
  ///
  /// In en, this message translates to:
  /// **'New arrivals this Frid…'**
  String get previewNewArrivalsFriday;

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get timeMonday;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @selectedDestination.
  ///
  /// In en, this message translates to:
  /// **'Selected destination'**
  String get selectedDestination;

  /// No description provided for @selectPickupDestPet.
  ///
  /// In en, this message translates to:
  /// **'Select pickup, destination, and a pet.'**
  String get selectPickupDestPet;

  /// No description provided for @pickupShort.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickupShort;

  /// No description provided for @destinationShort.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationShort;

  /// No description provided for @setPickup.
  ///
  /// In en, this message translates to:
  /// **'Set pickup'**
  String get setPickup;

  /// No description provided for @setDestination.
  ///
  /// In en, this message translates to:
  /// **'Set destination'**
  String get setDestination;

  /// No description provided for @choosePet.
  ///
  /// In en, this message translates to:
  /// **'Choose pet'**
  String get choosePet;

  /// No description provided for @couldNotLoadPets.
  ///
  /// In en, this message translates to:
  /// **'Could not load pets'**
  String get couldNotLoadPets;

  /// No description provided for @anyCar.
  ///
  /// In en, this message translates to:
  /// **'Any car'**
  String get anyCar;

  /// No description provided for @specificCar.
  ///
  /// In en, this message translates to:
  /// **'Specific'**
  String get specificCar;

  /// No description provided for @routeAndFare.
  ///
  /// In en, this message translates to:
  /// **'Route & fare'**
  String get routeAndFare;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From: {location}'**
  String fromLabel(String location);

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To: {location}'**
  String toLabel(String location);

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance: {km} km'**
  String distanceKm(String km);

  /// No description provided for @estimatedFare.
  ///
  /// In en, this message translates to:
  /// **'Estimated fare: {fare}'**
  String estimatedFare(String fare);

  /// No description provided for @fareFromServer.
  ///
  /// In en, this message translates to:
  /// **'Fare from calculateFare Cloud Function (server authoritative).'**
  String get fareFromServer;

  /// No description provided for @madaCard.
  ///
  /// In en, this message translates to:
  /// **'Mada / Card'**
  String get madaCard;

  /// No description provided for @defaultPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Default payment method'**
  String get defaultPaymentMethod;

  /// No description provided for @rideStatus.
  ///
  /// In en, this message translates to:
  /// **'Ride status'**
  String get rideStatus;

  /// No description provided for @rideNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ride not found'**
  String get rideNotFound;

  /// No description provided for @simulateDriverAllocated.
  ///
  /// In en, this message translates to:
  /// **'Simulate driver allocated'**
  String get simulateDriverAllocated;

  /// No description provided for @trackRide.
  ///
  /// In en, this message translates to:
  /// **'Track ride'**
  String get trackRide;

  /// No description provided for @confirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery'**
  String get confirmDelivery;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @mada.
  ///
  /// In en, this message translates to:
  /// **'Mada'**
  String get mada;

  /// No description provided for @petServiceCheckout.
  ///
  /// In en, this message translates to:
  /// **'Pet service checkout'**
  String get petServiceCheckout;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service History'**
  String get serviceHistory;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterRides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get filterRides;

  /// No description provided for @filterServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get filterServices;

  /// No description provided for @filterHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get filterHousing;

  /// No description provided for @filterSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get filterSupplies;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @historyHomeGrooming.
  ///
  /// In en, this message translates to:
  /// **'Home Grooming'**
  String get historyHomeGrooming;

  /// No description provided for @historyVetVisit.
  ///
  /// In en, this message translates to:
  /// **'Vet Home Visit'**
  String get historyVetVisit;

  /// No description provided for @historyBoarding.
  ///
  /// In en, this message translates to:
  /// **'Pet Boarding 3 nights'**
  String get historyBoarding;

  /// No description provided for @historySupplies.
  ///
  /// In en, this message translates to:
  /// **'Grooming Kit Supplies'**
  String get historySupplies;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @pendingRides.
  ///
  /// In en, this message translates to:
  /// **'Pending rides'**
  String get pendingRides;

  /// No description provided for @pendingVerifications.
  ///
  /// In en, this message translates to:
  /// **'Pending verifications'**
  String get pendingVerifications;

  /// No description provided for @pendingDriverRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending driver requests'**
  String get pendingDriverRequests;

  /// No description provided for @noPendingRideRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending ride requests.'**
  String get noPendingRideRequests;

  /// No description provided for @petLabel.
  ///
  /// In en, this message translates to:
  /// **'Pet: {petId}'**
  String petLabel(String petId);

  /// No description provided for @rideFareLabel.
  ///
  /// In en, this message translates to:
  /// **'Fare: {fare}'**
  String rideFareLabel(String fare);

  /// No description provided for @allocateDemoDriver.
  ///
  /// In en, this message translates to:
  /// **'Allocate demo driver'**
  String get allocateDemoDriver;

  /// No description provided for @mapsApiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Add GOOGLE_MAPS_API_KEY to run the map.\nSee README → Google Maps setup.'**
  String get mapsApiKeyMissing;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'5X XXX XXXX'**
  String get phonePlaceholder;

  /// No description provided for @devOtp.
  ///
  /// In en, this message translates to:
  /// **'Dev OTP: {code}'**
  String devOtp(String code);

  /// No description provided for @cityRiyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get cityRiyadh;

  /// No description provided for @cityJeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get cityJeddah;

  /// No description provided for @cityMecca.
  ///
  /// In en, this message translates to:
  /// **'Mecca'**
  String get cityMecca;

  /// No description provided for @cityMedina.
  ///
  /// In en, this message translates to:
  /// **'Medina'**
  String get cityMedina;

  /// No description provided for @cityDammam.
  ///
  /// In en, this message translates to:
  /// **'Dammam'**
  String get cityDammam;

  /// No description provided for @cityKhobar.
  ///
  /// In en, this message translates to:
  /// **'Khobar'**
  String get cityKhobar;

  /// No description provided for @cityTabuk.
  ///
  /// In en, this message translates to:
  /// **'Tabuk'**
  String get cityTabuk;

  /// No description provided for @cityAbha.
  ///
  /// In en, this message translates to:
  /// **'Abha'**
  String get cityAbha;

  /// No description provided for @cityDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai, UAE'**
  String get cityDubai;

  /// No description provided for @cityLahore.
  ///
  /// In en, this message translates to:
  /// **'Lahore, Pakistan'**
  String get cityLahore;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @listingNotFound.
  ///
  /// In en, this message translates to:
  /// **'Listing not found'**
  String get listingNotFound;

  /// No description provided for @thisPet.
  ///
  /// In en, this message translates to:
  /// **'this pet'**
  String get thisPet;

  /// No description provided for @petFallback.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get petFallback;

  /// No description provided for @uploadLicenseHint.
  ///
  /// In en, this message translates to:
  /// **'Upload license / ID documents'**
  String get uploadLicenseHint;

  /// No description provided for @rolePetOwner.
  ///
  /// In en, this message translates to:
  /// **'Pet Owner'**
  String get rolePetOwner;

  /// No description provided for @roleSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get roleSeller;

  /// No description provided for @roleProvider.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get roleProvider;

  /// No description provided for @roleHouser.
  ///
  /// In en, this message translates to:
  /// **'Boarding Provider'**
  String get roleHouser;

  /// No description provided for @roleClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get roleClinic;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (E.164)'**
  String get phoneInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {count} characters'**
  String passwordMinLength(int count);

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be {min}-{max} characters'**
  String usernameLength(int min, int max);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(String field);

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @savingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving changes..'**
  String get savingChanges;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBackUser(String name);

  /// No description provided for @noPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'No pets yet'**
  String get noPetsTitle;

  /// No description provided for @noPetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one to get started'**
  String get noPetsSubtitle;

  /// No description provided for @noActiveChats.
  ///
  /// In en, this message translates to:
  /// **'No active chats'**
  String get noActiveChats;

  /// No description provided for @noListingsFound.
  ///
  /// In en, this message translates to:
  /// **'No listings found'**
  String get noListingsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @deleteCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get deleteCannotUndo;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number or password'**
  String get invalidCredentials;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this number'**
  String get noAccountFound;

  /// No description provided for @otpRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Too many OTP requests. Try again in {minutes} minutes.'**
  String otpRateLimitExceeded(int minutes);

  /// No description provided for @welcomeNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pet Services!'**
  String get welcomeNotificationTitle;

  /// No description provided for @welcomeNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready. Explore services, buy pets, and book rides.'**
  String get welcomeNotificationBody;

  /// No description provided for @verificationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Verification request submitted'**
  String get verificationSubmitted;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
