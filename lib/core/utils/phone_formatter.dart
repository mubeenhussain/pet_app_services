/// Formats phone numbers for display, masking the middle digits.
abstract final class PhoneFormatter {
  PhoneFormatter._();

  /// Masks a phone number for OTP screens, e.g. `+966 501 ••• 4567`.
  static String mask(String raw) {
    final phone = raw.replaceAll(RegExp(r'\s+'), '');
    if (phone.length < 8) return phone;

    final last4 = phone.substring(phone.length - 4);

    if (phone.startsWith('+966') && phone.length >= 12) {
      final middle = phone.substring(4, 7);
      return '+966 $middle ••• $last4';
    }

    if (phone.startsWith('+97') && phone.length >= 11) {
      final middle = phone.substring(3, 6);
      return '+97 $middle ••• $last4';
    }

    if (phone.startsWith('+') && phone.length >= 10) {
      final prefixLen = phone.length - 7;
      final prefix = phone.substring(0, prefixLen);
      final middle = phone.substring(prefixLen, prefixLen + 3);
      return '$prefix $middle ••• $last4';
    }

    return phone;
  }
}
