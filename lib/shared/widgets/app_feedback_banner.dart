import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

enum AppFeedbackVariant { error, success, info }

/// Inline banner for field- and form-level feedback (login errors, OTP success, etc.).
class AppFeedbackBanner extends StatelessWidget {
  const AppFeedbackBanner({
    super.key,
    required this.message,
    this.variant = AppFeedbackVariant.error,
    this.icon,
    this.trailing,
  });

  final String message;
  final AppFeedbackVariant variant;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, defaultIcon) = switch (variant) {
      AppFeedbackVariant.error => (
          AppColors.feedbackErrorBg,
          AppColors.feedbackErrorBorder,
          AppColors.feedbackErrorText,
          Icons.info_outline_rounded,
        ),
      AppFeedbackVariant.success => (
          AppColors.feedbackSuccessBg,
          AppColors.feedbackSuccessBorder,
          AppColors.feedbackSuccessText,
          Icons.check_circle_outline_rounded,
        ),
      AppFeedbackVariant.info => (
          AppColors.feedbackSuccessBg,
          AppColors.feedbackSuccessBorder,
          AppColors.feedbackSuccessText,
          Icons.info_outline_rounded,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon ?? defaultIcon, size: 18, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: fg,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
