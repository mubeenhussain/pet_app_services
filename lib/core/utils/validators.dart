import 'package:pet_app/core/constants/app_constants.dart';

class Validators {
  Validators._();

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final normalized = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(normalized)) {
      return 'Enter a valid phone number (E.164)';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < AppConstants.minUsernameLength ||
        trimmed.length > AppConstants.maxUsernameLength) {
      return 'Username must be ${AppConstants.minUsernameLength}-${AppConstants.maxUsernameLength} characters';
    }
    return null;
  }

  static String? requiredField(String? value, {String field = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
