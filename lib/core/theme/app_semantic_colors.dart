import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Semantic colors not covered by [ColorScheme].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.emergency,
    required this.border,
    required this.textSecondary,
    required this.primaryDark,
  });

  final Color success;
  final Color emergency;
  final Color border;
  final Color textSecondary;
  final Color primaryDark;

  static const light = AppSemanticColors(
    success: AppColors.success,
    emergency: AppColors.emergency,
    border: AppColors.border,
    textSecondary: AppColors.textSecondary,
    primaryDark: AppColors.primaryDark,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? emergency,
    Color? border,
    Color? textSecondary,
    Color? primaryDark,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      emergency: emergency ?? this.emergency,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
      primaryDark: primaryDark ?? this.primaryDark,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      emergency: Color.lerp(emergency, other.emergency, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
    );
  }
}
