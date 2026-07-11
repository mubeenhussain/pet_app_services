// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'خدمات الحيوانات الأليفة';

  @override
  String get loginTitle => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لمواصلة العناية بحيواناتك';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get noAccountPrompt => 'ليس لديك حساب؟';

  @override
  String get phoneHint => 'رقم الهاتف';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInWithGoogle => 'تسجيل الدخول عبر Google';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل رقم هاتفك وسنرسل لك رمزاً لإعادة التعيين';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get resetCodeSent => 'تم إرسال رمز إعادة التعيين';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get setPasswordTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get setPasswordSubtitle => 'أنشئ كلمة مرور قوية لتأمين حسابك';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get strengthWeak => 'ضعيفة';

  @override
  String get strengthFair => 'متوسطة';

  @override
  String get strengthGood => 'جيدة';

  @override
  String get strengthStrong => 'قوية';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم إلى PawBuddy وابدأ رحلة حيوانك الأليف';

  @override
  String get usernameHint => 'اسم المستخدم';

  @override
  String get usernameExample => 'مثال: sara_khan';

  @override
  String get phoneExample => '300 1234567';

  @override
  String get passwordMinHint => '8 أحرف على الأقل';

  @override
  String get passwordHelper => '8 أحرف كحد أدنى';

  @override
  String get cityAddressLabel => 'المدينة / العنوان';

  @override
  String get selectCity => 'اختر مدينتك';

  @override
  String get optional => 'اختياري';

  @override
  String get agreeToTerms => 'أوافق على';

  @override
  String get termsAndPrivacy => 'الشروط وسياسة الخصوصية';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get mustAcceptTerms => 'يرجى قبول الشروط للمتابعة';

  @override
  String get cityHint => 'المدينة';

  @override
  String get submit => 'إرسال';

  @override
  String get otpTitle => 'تأكيد رقمك';

  @override
  String otpSubtitle(String phone) {
    return 'أدخل الرمز المرسل إلى $phone';
  }

  @override
  String otpInstruction(int length) {
    return 'أدخل الرمز المكوّن من $length أرقام المرسل إلى';
  }

  @override
  String otpInvalid(int length) {
    return 'أدخل الرمز المكوّن من $length أرقام';
  }

  @override
  String get otpResent => 'تمت إعادة إرسال الرمز';

  @override
  String get didntGetCode => 'لم يصلك الرمز؟';

  @override
  String resendIn(String time) {
    return 'إعادة الإرسال خلال $time';
  }

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String homeGreeting(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get yourPets => 'حيواناتك';

  @override
  String get orders => 'الطلبات';

  @override
  String get accountType => 'نوع الحساب';

  @override
  String get userSettings => 'إعدادات المستخدم';

  @override
  String get addPet => 'إضافة حيوان';

  @override
  String get noPetsYet => 'لا توجد حيوانات بعد — أضف واحداً';

  @override
  String get petName => 'اسم الحيوان';

  @override
  String get species => 'النوع';

  @override
  String get breed => 'السلالة';

  @override
  String get age => 'العمر';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get requestRide => 'طلب توصيل الحيوان';

  @override
  String get pickup => 'موقع الاستلام';

  @override
  String get destination => 'الوجهة';

  @override
  String get selectPet => 'اختر الحيوان';

  @override
  String get checkout => 'الدفع';

  @override
  String get confirmAndPay => 'تأكيد والدفع';

  @override
  String get paymentSuccess => 'تم الدفع بنجاح';

  @override
  String get paymentFailed => 'فشل الدفع';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get errorGeneric => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get verificationPending => 'التحقق قيد الانتظار';

  @override
  String get documentUpload => 'رفع المستندات';

  @override
  String get searchingForDriver => 'جاري البحث عن سائق...';

  @override
  String get driverAllocated => 'تم تعيين السائق';

  @override
  String get deliveryConfirmed => 'تم تأكيد التسليم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get guestUser => 'زائر';

  @override
  String get guestProfileMessage =>
      'أنت تتصفح كزائر. سجّل الدخول لحفظ ملفك وحيواناتك.';

  @override
  String get homeWelcome => 'مرحباً،';

  @override
  String get homeServices => 'الخدمات';

  @override
  String get homeBuySell => 'شراء وبيع';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeRescueBanner => 'إنقاذ نشط بالقرب منك — اضغط للمساعدة';

  @override
  String get homeGrooming => 'العناية';

  @override
  String get homeDelivery => 'التوصيل';

  @override
  String get homeBoarding => 'الإيواء';

  @override
  String get homeShower => 'الاستحمام';

  @override
  String get homeSupplies => 'المستلزمات';

  @override
  String get homeRescue => 'الإنقاذ';

  @override
  String get homeRide => 'التوصيل';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navServices => 'الخدمات';

  @override
  String get navRescue => 'الإنقاذ';

  @override
  String get navProfile => 'الملف';

  @override
  String get switchToArabic => 'التبديل إلى العربية';

  @override
  String get switchToEnglish => 'التبديل إلى الإنجليزية';

  @override
  String get listingLabradorPup => 'جرو لابرادور';

  @override
  String get listingCockatiel => 'كوكاتيل';

  @override
  String get listingArabianHorse => 'حصان عربي';

  @override
  String get tabServicesTitle => 'الخدمات';

  @override
  String get tabServicesSubtitle => 'تصفح خدمات الحيوانات';

  @override
  String get tabRescueTitle => 'الإنقاذ';

  @override
  String get tabRescueSubtitle => 'إنقاذ طارئ — قريباً';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get verified => 'موثّق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String get filters => 'الفلاتر';

  @override
  String get category => 'الفئة';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String applyWithCount(int count) {
    return 'تطبيق ($count نتيجة)';
  }

  @override
  String sarAmountFormatted(String amount) {
    return '$amount ر.س';
  }

  @override
  String ageYear(int count) {
    return '$count سنة';
  }

  @override
  String ageYears(int count) {
    return '$count سنوات';
  }

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get gender => 'الجنس';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get messages => 'الرسائل';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String memberSince(int year) {
    return 'عضو منذ $year';
  }

  @override
  String get labelPhone => 'الهاتف';

  @override
  String get labelCity => 'المدينة';

  @override
  String get labelEmail => 'البريد الإلكتروني';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get photoUpdateSoon => 'تحديث الصورة قريباً';

  @override
  String get tapChangePhoto => 'اضغط لتغيير الصورة';

  @override
  String get signInToSavePet => 'يرجى تسجيل الدخول لحفظ الحيوان';

  @override
  String get petSaved => 'تم حفظ الحيوان';

  @override
  String get petUpdated => 'تم تحديث الحيوان';

  @override
  String get petDeleted => 'تم حذف الحيوان';

  @override
  String get addNewPet => 'إضافة حيوان جديد';

  @override
  String get editPet => 'تعديل الحيوان';

  @override
  String get savePet => 'حفظ الحيوان';

  @override
  String get myPets => 'حيواناتي';

  @override
  String get nameHintBuddy => 'مثال: بادي';

  @override
  String get breedHintGoldenRetriever => 'مثال: جولدن ريتريفر';

  @override
  String get speciesDog => 'كلب';

  @override
  String get speciesCat => 'قطة';

  @override
  String get speciesBird => 'طائر';

  @override
  String get speciesOther => 'أخرى';

  @override
  String get photoUploadSoon => 'رفع الصورة قريباً';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get deletePet => 'حذف الحيوان';

  @override
  String deletePetConfirm(String name) {
    return 'إزالة $name؟';
  }

  @override
  String get petNotFound => 'الحيوان غير موجود';

  @override
  String editPetName(String name) {
    return 'تعديل $name';
  }

  @override
  String get buyAPet => 'شراء حيوان';

  @override
  String get searchBreedCity => 'ابحث عن السلالة، المدينة...';

  @override
  String get loadingMore => 'جاري تحميل المزيد...';

  @override
  String get providerDetails => 'تفاصيل المزوّد';

  @override
  String get flagInterestReport => 'الإبلاغ / الإبلاغ عن اهتمام';

  @override
  String get askAboutPet => 'اسأل عن الحيوان';

  @override
  String get buyNow => 'اشترِ الآن';

  @override
  String askAbout(String name) {
    return 'اسأل عن $name';
  }

  @override
  String get yourMessage => 'رسالتك';

  @override
  String get sendMessage => 'إرسال الرسالة';

  @override
  String askDefaultMessage(String name) {
    return 'مرحباً، أنا مهتم بـ $name — هل $name متاح؟';
  }

  @override
  String breedPriceLine(String breed, String price) {
    return '$breed · $price';
  }

  @override
  String get categoryDogs => 'كلاب';

  @override
  String get categoryCats => 'قطط';

  @override
  String get categoryBirds => 'طيور';

  @override
  String get categoryHorses => 'خيول';

  @override
  String get categoryCamels => 'إبل';

  @override
  String get categoryAdoption => 'تبنٍ';

  @override
  String get chatTitle => 'محادثة';

  @override
  String get activeNow => 'متصل الآن';

  @override
  String get chatSafetyBanner => 'يتم مراقبة هذه المحادثة للسلامة';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get contactInfoWarning => 'الرسالة تحتوي على معلومات اتصال';

  @override
  String get demoMsgKittenAvailable =>
      'مرحباً! هل القطة الفارسية ما زالت متاحة؟';

  @override
  String get demoMsgKittenReply => 'نعم! مُطعّمة وجاهزة للتبنّي 🐱';

  @override
  String get demoMsgKittenConfirm =>
      'ممتاز، شكراً! تُقفل المحادثة بعد التأكيد 🔒';

  @override
  String get previewPersianAvailable => 'هل القطة الفارسية ما ز…';

  @override
  String get previewDeliverSaturday => 'يمكننا توصيلها يوم الس…';

  @override
  String get previewThankYouSaturday => 'شكراً! نراك يوم الس…';

  @override
  String get previewNewArrivalsFriday => 'وصول جديد يوم الجمعة…';

  @override
  String get timeYesterday => 'أمس';

  @override
  String get timeMonday => 'الإثنين';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get selectedDestination => 'الوجهة المحددة';

  @override
  String get selectPickupDestPet => 'اختر نقطة الاستلام والوجهة والحيوان.';

  @override
  String get pickupShort => 'الاستلام';

  @override
  String get destinationShort => 'الوجهة';

  @override
  String get setPickup => 'تعيين الاستلام';

  @override
  String get setDestination => 'تعيين الوجهة';

  @override
  String get choosePet => 'اختر الحيوان';

  @override
  String get couldNotLoadPets => 'تعذّر تحميل الحيوانات';

  @override
  String get anyCar => 'أي سيارة';

  @override
  String get specificCar => 'محددة';

  @override
  String get routeAndFare => 'المسار والأجرة';

  @override
  String fromLabel(String location) {
    return 'من: $location';
  }

  @override
  String toLabel(String location) {
    return 'إلى: $location';
  }

  @override
  String distanceKm(String km) {
    return 'المسافة: $km كم';
  }

  @override
  String estimatedFare(String fare) {
    return 'الأجرة التقديرية: $fare';
  }

  @override
  String get fareFromServer =>
      'الأجرة من دالة calculateFare (الخادم هو المرجع).';

  @override
  String get madaCard => 'مدى / بطاقة';

  @override
  String get defaultPaymentMethod => 'طريقة الدفع الافتراضية';

  @override
  String get rideStatus => 'حالة الرحلة';

  @override
  String get rideNotFound => 'الرحلة غير موجودة';

  @override
  String get simulateDriverAllocated => 'محاكاة تعيين سائق';

  @override
  String get trackRide => 'تتبع الرحلة';

  @override
  String get confirmDelivery => 'تأكيد التسليم';

  @override
  String get deliveryAddress => 'عنوان التسليم';

  @override
  String get mada => 'مدى';

  @override
  String get petServiceCheckout => 'دفع خدمة الحيوان';

  @override
  String get serviceHistory => 'سجل الخدمات';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterRides => 'الرحلات';

  @override
  String get filterServices => 'الخدمات';

  @override
  String get filterHousing => 'الإيواء';

  @override
  String get filterSupplies => 'المستلزمات';

  @override
  String get noHistoryYet => 'لا يوجد سجل بعد';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get historyHomeGrooming => 'عناية منزلية';

  @override
  String get historyVetVisit => 'زيارة بيطرية منزلية';

  @override
  String get historyBoarding => 'إيواء 3 ليالٍ';

  @override
  String get historySupplies => 'مستلزمات العناية';

  @override
  String get adminDashboard => 'لوحة الإدارة';

  @override
  String get pendingRides => 'رحلات قيد الانتظار';

  @override
  String get pendingVerifications => 'تحققات قيد الانتظار';

  @override
  String get pendingDriverRequests => 'طلبات السائقين المعلّقة';

  @override
  String get noPendingRideRequests => 'لا توجد طلبات رحلات معلّقة.';

  @override
  String petLabel(String petId) {
    return 'الحيوان: $petId';
  }

  @override
  String rideFareLabel(String fare) {
    return 'الأجرة: $fare';
  }

  @override
  String get allocateDemoDriver => 'تعيين سائق تجريبي';

  @override
  String get mapsApiKeyMissing =>
      'أضف GOOGLE_MAPS_API_KEY لتشغيل الخريطة.\nراجع README → إعداد خرائط Google.';

  @override
  String get phonePlaceholder => '5X XXX XXXX';

  @override
  String devOtp(String code) {
    return 'رمز التطوير: $code';
  }

  @override
  String get cityRiyadh => 'الرياض';

  @override
  String get cityJeddah => 'جدة';

  @override
  String get cityMecca => 'مكة';

  @override
  String get cityMedina => 'المدينة';

  @override
  String get cityDammam => 'الدمام';

  @override
  String get cityKhobar => 'الخبر';

  @override
  String get cityTabuk => 'تبوك';

  @override
  String get cityAbha => 'أبها';

  @override
  String get cityDubai => 'دبي، الإمارات';

  @override
  String get cityLahore => 'لاهور، باكستان';

  @override
  String get userFallback => 'مستخدم';

  @override
  String get listingNotFound => 'الإعلان غير موجود';

  @override
  String get thisPet => 'هذا الحيوان';

  @override
  String get petFallback => 'حيوان';

  @override
  String get uploadLicenseHint => 'ارفع رخصة القيادة / الهوية';

  @override
  String get rolePetOwner => 'مالك حيوان';

  @override
  String get roleSeller => 'بائع';

  @override
  String get roleProvider => 'مقدّم خدمة';

  @override
  String get roleHouser => 'مقدّم إيواء';

  @override
  String get roleClinic => 'عيادة';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneInvalid => 'أدخل رقم هاتف صالحاً (E.164)';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String passwordMinLength(int count) {
    return 'يجب أن تكون كلمة المرور $count أحرف على الأقل';
  }

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String usernameLength(int min, int max) {
    return 'يجب أن يكون اسم المستخدم بين $min و$max حرفاً';
  }

  @override
  String fieldRequired(String field) {
    return '$field مطلوب';
  }

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get signingIn => 'جارٍ تسجيل الدخول...';

  @override
  String get savingChanges => 'جارٍ حفظ التغييرات..';

  @override
  String welcomeBackUser(String name) {
    return 'مرحباً بعودتك، $name!';
  }

  @override
  String get noPetsTitle => 'لا توجد حيوانات بعد';

  @override
  String get noPetsSubtitle => 'أضف حيواناً للبدء';

  @override
  String get noActiveChats => 'لا توجد محادثات نشطة';

  @override
  String get noListingsFound => 'لم يتم العثور على إعلانات';

  @override
  String get tryAdjustingFilters => 'جرّب تعديل عوامل التصفية';

  @override
  String get deleteCannotUndo => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get invalidCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة';

  @override
  String get noAccountFound => 'لا يوجد حساب بهذا الرقم';

  @override
  String otpRateLimitExceeded(int minutes) {
    return 'طلبات رمز التحقق كثيرة جداً. حاول مرة أخرى خلال $minutes دقائق.';
  }

  @override
  String get welcomeNotificationTitle => 'مرحباً بك في خدمات الحيوانات!';

  @override
  String get welcomeNotificationBody =>
      'حسابك جاهز. استكشف الخدمات واشترِ الحيوانات واحجز الرحلات.';

  @override
  String get verificationSubmitted => 'تم إرسال طلب التحقق';

  @override
  String get dismiss => 'إغلاق';
}
