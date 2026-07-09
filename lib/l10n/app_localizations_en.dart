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

  @override
  String get homeWelcome => 'Welcome,';

  @override
  String get homeServices => 'Services';

  @override
  String get homeBuySell => 'Buy & Sell';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeRescueBanner => 'Active rescue nearby — tap to help';

  @override
  String get homeGrooming => 'Grooming';

  @override
  String get homeDelivery => 'Delivery';

  @override
  String get homeBoarding => 'Boarding';

  @override
  String get homeShower => 'Shower';

  @override
  String get homeSupplies => 'Supplies';

  @override
  String get homeRescue => 'Rescue';

  @override
  String get homeRide => 'Ride';

  @override
  String get navHome => 'Home';

  @override
  String get navServices => 'Services';

  @override
  String get navRescue => 'Rescue';

  @override
  String get navProfile => 'Profile';

  @override
  String get switchToArabic => 'Switch to Arabic';

  @override
  String get switchToEnglish => 'Switch to English';

  @override
  String get listingLabradorPup => 'Labrador Pup';

  @override
  String get listingCockatiel => 'Cockatiel';

  @override
  String get listingArabianHorse => 'Arabian Horse';

  @override
  String get tabServicesTitle => 'Services';

  @override
  String get tabServicesSubtitle => 'Browse pet services';

  @override
  String get tabRescueTitle => 'Rescue';

  @override
  String get tabRescueSubtitle => 'Emergency rescue — coming soon';

  @override
  String get retry => 'Retry';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get verified => 'Verified';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get filters => 'Filters';

  @override
  String get category => 'Category';

  @override
  String get priceRange => 'Price Range';

  @override
  String applyWithCount(int count) {
    return 'Apply ($count results)';
  }

  @override
  String sarAmountFormatted(String amount) {
    return 'SAR $amount';
  }

  @override
  String ageYear(int count) {
    return '$count yr';
  }

  @override
  String ageYears(int count) {
    return '$count yrs';
  }

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get gender => 'Gender';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get messages => 'Messages';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String memberSince(int year) {
    return 'Member since $year';
  }

  @override
  String get labelPhone => 'PHONE';

  @override
  String get labelCity => 'CITY';

  @override
  String get labelEmail => 'EMAIL';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get photoUpdateSoon => 'Photo update coming soon';

  @override
  String get tapChangePhoto => 'Tap to change photo';

  @override
  String get signInToSavePet => 'Please sign in to save a pet';

  @override
  String get petSaved => 'Pet saved';

  @override
  String get petUpdated => 'Pet updated';

  @override
  String get petDeleted => 'Pet deleted';

  @override
  String get addNewPet => 'Add New Pet';

  @override
  String get editPet => 'Edit Pet';

  @override
  String get savePet => 'Save Pet';

  @override
  String get myPets => 'My Pets';

  @override
  String get nameHintBuddy => 'e.g. Buddy';

  @override
  String get breedHintGoldenRetriever => 'e.g. Golden Retriever';

  @override
  String get speciesDog => 'Dog';

  @override
  String get speciesCat => 'Cat';

  @override
  String get speciesBird => 'Bird';

  @override
  String get speciesOther => 'Other';

  @override
  String get photoUploadSoon => 'Photo upload coming soon';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get deletePet => 'Delete Pet';

  @override
  String deletePetConfirm(String name) {
    return 'Remove $name?';
  }

  @override
  String get petNotFound => 'Pet not found';

  @override
  String editPetName(String name) {
    return 'Edit $name';
  }

  @override
  String get buyAPet => 'Buy a Pet';

  @override
  String get searchBreedCity => 'Search breed, city...';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get providerDetails => 'Provider Details';

  @override
  String get flagInterestReport => 'Flag Interest / Report';

  @override
  String get askAboutPet => 'Ask About Pet';

  @override
  String get buyNow => 'Buy Now';

  @override
  String askAbout(String name) {
    return 'Ask about $name';
  }

  @override
  String get yourMessage => 'YOUR MESSAGE';

  @override
  String get sendMessage => 'Send Message';

  @override
  String askDefaultMessage(String name) {
    return 'Hi, I\'m interested in $name — is $name still available?';
  }

  @override
  String breedPriceLine(String breed, String price) {
    return '$breed · $price';
  }

  @override
  String get categoryDogs => 'Dogs';

  @override
  String get categoryCats => 'Cats';

  @override
  String get categoryBirds => 'Birds';

  @override
  String get categoryHorses => 'Horses';

  @override
  String get categoryCamels => 'Camels';

  @override
  String get categoryAdoption => 'Adoption';

  @override
  String get chatTitle => 'Chat';

  @override
  String get activeNow => 'Active now';

  @override
  String get chatSafetyBanner => 'This chat is monitored for safety';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get contactInfoWarning => 'Message contains contact info';

  @override
  String get demoMsgKittenAvailable =>
      'Hi! Is the Persian kitten still available?';

  @override
  String get demoMsgKittenReply => 'Yes she is! Vaccinated and ready to go 🐱';

  @override
  String get demoMsgKittenConfirm =>
      'Perfect, thank you! Chat locked once we confirm 🔒';

  @override
  String get previewPersianAvailable => 'Is the Persian still avai…';

  @override
  String get previewDeliverSaturday => 'We can deliver it Satur…';

  @override
  String get previewThankYouSaturday => 'Thank you! See you S…';

  @override
  String get previewNewArrivalsFriday => 'New arrivals this Frid…';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get timeMonday => 'Mon';

  @override
  String get currentLocation => 'Current location';

  @override
  String get selectedDestination => 'Selected destination';

  @override
  String get selectPickupDestPet => 'Select pickup, destination, and a pet.';

  @override
  String get pickupShort => 'Pickup';

  @override
  String get destinationShort => 'Destination';

  @override
  String get setPickup => 'Set pickup';

  @override
  String get setDestination => 'Set destination';

  @override
  String get choosePet => 'Choose pet';

  @override
  String get couldNotLoadPets => 'Could not load pets';

  @override
  String get anyCar => 'Any car';

  @override
  String get specificCar => 'Specific';

  @override
  String get routeAndFare => 'Route & fare';

  @override
  String fromLabel(String location) {
    return 'From: $location';
  }

  @override
  String toLabel(String location) {
    return 'To: $location';
  }

  @override
  String distanceKm(String km) {
    return 'Distance: $km km';
  }

  @override
  String estimatedFare(String fare) {
    return 'Estimated fare: $fare';
  }

  @override
  String get fareFromServer =>
      'Fare from calculateFare Cloud Function (server authoritative).';

  @override
  String get madaCard => 'Mada / Card';

  @override
  String get defaultPaymentMethod => 'Default payment method';

  @override
  String get rideStatus => 'Ride status';

  @override
  String get rideNotFound => 'Ride not found';

  @override
  String get simulateDriverAllocated => 'Simulate driver allocated';

  @override
  String get trackRide => 'Track ride';

  @override
  String get confirmDelivery => 'Confirm delivery';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get mada => 'Mada';

  @override
  String get petServiceCheckout => 'Pet service checkout';

  @override
  String get serviceHistory => 'Service History';

  @override
  String get filterAll => 'All';

  @override
  String get filterRides => 'Rides';

  @override
  String get filterServices => 'Services';

  @override
  String get filterHousing => 'Housing';

  @override
  String get filterSupplies => 'Supplies';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get historyHomeGrooming => 'Home Grooming';

  @override
  String get historyVetVisit => 'Vet Home Visit';

  @override
  String get historyBoarding => 'Pet Boarding 3 nights';

  @override
  String get historySupplies => 'Grooming Kit Supplies';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get pendingRides => 'Pending rides';

  @override
  String get pendingVerifications => 'Pending verifications';

  @override
  String get pendingDriverRequests => 'Pending driver requests';

  @override
  String get noPendingRideRequests => 'No pending ride requests.';

  @override
  String petLabel(String petId) {
    return 'Pet: $petId';
  }

  @override
  String rideFareLabel(String fare) {
    return 'Fare: $fare';
  }

  @override
  String get allocateDemoDriver => 'Allocate demo driver';

  @override
  String get mapsApiKeyMissing =>
      'Add GOOGLE_MAPS_API_KEY to run the map.\nSee README → Google Maps setup.';

  @override
  String get phonePlaceholder => '5X XXX XXXX';

  @override
  String devOtp(String code) {
    return 'Dev OTP: $code';
  }

  @override
  String get cityRiyadh => 'Riyadh';

  @override
  String get cityJeddah => 'Jeddah';

  @override
  String get cityMecca => 'Mecca';

  @override
  String get cityMedina => 'Medina';

  @override
  String get cityDammam => 'Dammam';

  @override
  String get cityKhobar => 'Khobar';

  @override
  String get cityTabuk => 'Tabuk';

  @override
  String get cityAbha => 'Abha';

  @override
  String get cityDubai => 'Dubai, UAE';

  @override
  String get cityLahore => 'Lahore, Pakistan';

  @override
  String get userFallback => 'User';

  @override
  String get listingNotFound => 'Listing not found';

  @override
  String get thisPet => 'this pet';

  @override
  String get petFallback => 'Pet';

  @override
  String get uploadLicenseHint => 'Upload license / ID documents';

  @override
  String get rolePetOwner => 'Pet Owner';

  @override
  String get roleSeller => 'Seller';

  @override
  String get roleProvider => 'Service Provider';

  @override
  String get roleHouser => 'Boarding Provider';

  @override
  String get roleClinic => 'Clinic';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Enter a valid phone number (E.164)';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordMinLength(int count) {
    return 'Password must be at least $count characters';
  }

  @override
  String get usernameRequired => 'Username is required';

  @override
  String usernameLength(int min, int max) {
    return 'Username must be $min-$max characters';
  }

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
}
