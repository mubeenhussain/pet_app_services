import 'package:flutter/material.dart';

/// Raw design tokens — use only inside [AppTheme], never in feature widgets.
abstract final class AppColors {
  AppColors._();

  static const primary = Color(0xFF22A45D);
  static const primaryDark = Color(0xFF16794A);
  static const secondary = Color(0xFFFF8F00);
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFC9E9D4);
  static const emergency = Color(0xFFC62828);
  static const onPrimary = Color(0xFFFFFFFF);
}
