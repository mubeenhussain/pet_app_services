import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

abstract final class AppTextTheme {
  AppTextTheme._();

  static TextTheme light(ColorScheme colorScheme) {
    return TextTheme(
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
