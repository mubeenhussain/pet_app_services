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
}
