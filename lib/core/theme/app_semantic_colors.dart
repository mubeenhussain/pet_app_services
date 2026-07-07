import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Semantic colors not covered by [ColorScheme].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.emergency,
    required this.border,
    required this.divider,
    required this.link,
    required this.textSecondary,
    required this.textMuted,
    required this.primaryDark,
  });

  final Color success;
  final Color emergency;
  final Color border;
  final Color divider;
  final Color link;
  final Color textSecondary;
  final Color textMuted;
  final Color primaryDark;

  static const light = AppSemanticColors(
    success: AppColors.success,
    emergency: AppColors.emergency,
    border: AppColors.border,
    divider: AppColors.divider,
    link: AppColors.link,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    primaryDark: AppColors.primaryDark,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? emergency,
    Color? border,
    Color? divider,
    Color? link,
    Color? textSecondary,
    Color? textMuted,
    Color? primaryDark,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      emergency: emergency ?? this.emergency,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      link: link ?? this.link,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
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
      divider: Color.lerp(divider, other.divider, t)!,
      link: Color.lerp(link, other.link, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
    );
  }
}
