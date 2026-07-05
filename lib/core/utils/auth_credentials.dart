import 'package:pet_app/shared/services/phone_auth_service.dart';

class AuthCredentials {
  AuthCredentials._();

  /// Maps BRD phone login to Firebase Email auth until Phone+Password native support.
  static String phoneToEmail(String phone) {
    final normalized = PhoneAuthService.normalizePhone(phone);
    final digits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    return 'phone_$digits@pets.app';
  }
}
