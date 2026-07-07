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
  String get skipForNow => 'تخطي الآن';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get usernameHint => 'اسم المستخدم';

  @override
  String get cityHint => 'المدينة';

  @override
  String get submit => 'إرسال';

  @override
  String get otpTitle => 'تحقق من الهاتف';

  @override
  String otpSubtitle(String phone) {
    return 'أدخل الرمز المرسل إلى $phone';
  }

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
