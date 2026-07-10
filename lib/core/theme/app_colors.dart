import 'package:flutter/material.dart';

/// Raw design tokens — use only inside [AppTheme], never in feature widgets.
abstract final class AppColors {
  AppColors._();

  static const primary = Color(0xFF22A45D);
  static const primaryDark = Color(0xFF16794A);
  static const heading = Color(0xFF0B3B22);
  static const secondary = Color(0xFFFF8F00);
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF95A29A);
  static const border = Color(0xFFC9E9D4);
  static const divider = Color(0xFFEDF0F2);
  static const link = Color(0xFF0F8A42);
  static const emergency = Color(0xFFC62828);
  static const onPrimary = Color(0xFFFFFFFF);

  // States & feedback (Figma)
  static const feedbackErrorBg = Color(0xFFFFF1F1);
  static const feedbackErrorBorder = Color(0xFFF5C2C2);
  static const feedbackErrorText = Color(0xFFB23A3E);
  static const feedbackSuccessBg = Color(0xFFE8F7EE);
  static const feedbackSuccessBorder = Color(0xFFC9E9D4);
  static const feedbackSuccessText = Color(0xFF0F8A42);
  static const skeleton = Color(0xFFE4EDE7);
  static const skeletonHighlight = Color(0xFFF0F5F2);
}
