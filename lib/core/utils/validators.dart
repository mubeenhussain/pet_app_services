import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/l10n/app_localizations.dart';

class Validators {
  Validators._();

  static String? Function(String?) phone(AppLocalizations l10n) => (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.phoneRequired;
        }
        final normalized = value.replaceAll(RegExp(r'\s+'), '');
        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(normalized)) {
          return l10n.phoneInvalid;
        }
        return null;
      };

  static String? Function(String?) password(AppLocalizations l10n) => (value) {
        if (value == null || value.isEmpty) {
          return l10n.passwordRequired;
        }
        if (value.length < AppConstants.minPasswordLength) {
          return l10n.passwordMinLength(AppConstants.minPasswordLength);
        }
        return null;
      };

  static String? Function(String?) username(AppLocalizations l10n) => (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.usernameRequired;
        }
        final trimmed = value.trim();
        if (trimmed.length < AppConstants.minUsernameLength ||
            trimmed.length > AppConstants.maxUsernameLength) {
          return l10n.usernameLength(
            AppConstants.minUsernameLength,
            AppConstants.maxUsernameLength,
          );
        }
        return null;
      };

  static String? Function(String?) requiredField(
    AppLocalizations l10n, {
    required String field,
  }) =>
      (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.fieldRequired(field);
        }
        return null;
      };

  static String? Function(String?) confirmPassword(
    AppLocalizations l10n,
    String password,
  ) =>
      (value) {
        if (value != password) {
          return l10n.passwordsDoNotMatch;
        }
        return null;
      };
}
