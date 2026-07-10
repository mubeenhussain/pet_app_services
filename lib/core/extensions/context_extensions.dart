import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/core/theme/app_semantic_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppSemanticColors get colors =>
      Theme.of(this).extension<AppSemanticColors>()!;

  Size get screenSize => MediaQuery.sizeOf(this);

  void showAppSnackBar(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? AppColors.feedbackErrorText
            : isSuccess
                ? AppColors.feedbackSuccessText
                : null,
      ),
    );
  }
}
