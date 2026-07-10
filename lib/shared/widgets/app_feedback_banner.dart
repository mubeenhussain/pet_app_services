import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

enum AppFeedbackVariant { error, success, info, chatSafety, chatWarning }

enum AppFeedbackLayout { fullWidth, compact }

/// Reusable inline banner for forms, auth, and chat (Figma states & feedback).
class AppFeedbackBanner extends StatelessWidget {
  const AppFeedbackBanner({
    super.key,
    required this.message,
    this.variant = AppFeedbackVariant.error,
    this.layout = AppFeedbackLayout.fullWidth,
    this.icon,
    this.trailing,
  });

  final String message;
  final AppFeedbackVariant variant;
  final AppFeedbackLayout layout;
  final IconData? icon;
  final Widget? trailing;

  static const _designScreenWidth = 390.0;
  static const _compactHeight = 32.0;
  static const _compactRadius = 12.0;
  static const _listHorizontalPadding = 16.0;

  static double compactWidth(BuildContext context, double designWidth) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth - (_listHorizontalPadding * 2);
    return (screenWidth * designWidth / _designScreenWidth).clamp(0, maxWidth);
  }

  @override
  Widget build(BuildContext context) {
    if (layout == AppFeedbackLayout.compact) {
      return _buildCompact(context);
    }
    return _buildFullWidth();
  }

  Widget _buildCompact(BuildContext context) {
    final spec = _compactSpec(variant);
    final width = compactWidth(context, spec.designWidth);

    return SizedBox(
      width: width,
      height: _compactHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: spec.background,
          borderRadius: BorderRadius.circular(_compactRadius),
          border: spec.border != null ? Border.all(color: spec.border!) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon ?? spec.icon, size: spec.iconSize, color: spec.foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: spec.fontSize,
                    fontWeight: FontWeight.w600,
                    height: spec.lineHeight / spec.fontSize,
                    letterSpacing: 0,
                    color: spec.foreground,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidth() {
    final spec = _fullWidthSpec(variant);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: spec.background,
        borderRadius: BorderRadius.circular(_compactRadius),
        border: Border.all(color: spec.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon ?? spec.icon, size: 18, color: spec.foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: spec.foreground,
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

  _CompactSpec _compactSpec(AppFeedbackVariant value) => switch (value) {
        AppFeedbackVariant.chatSafety => const _CompactSpec(
            designWidth: 318,
            background: AppColors.chatIncomingBubble,
            foreground: AppColors.link,
            icon: Icons.lock_outline_rounded,
            iconSize: 12,
            fontSize: 10.5,
            lineHeight: 15.75,
          ),
        AppFeedbackVariant.chatWarning => const _CompactSpec(
            designWidth: 242,
            background: AppColors.chatWarningBg,
            foreground: AppColors.feedbackErrorText,
            icon: Icons.error_outline_rounded,
            iconSize: 14,
            fontSize: 12,
            lineHeight: 16,
          ),
        _ => const _CompactSpec(
            designWidth: 318,
            background: AppColors.feedbackErrorBg,
            border: AppColors.feedbackErrorBorder,
            foreground: AppColors.feedbackErrorText,
            icon: Icons.info_outline_rounded,
            iconSize: 14,
            fontSize: 12,
            lineHeight: 16,
          ),
      };

  _FullWidthSpec _fullWidthSpec(AppFeedbackVariant value) => switch (value) {
        AppFeedbackVariant.success => const _FullWidthSpec(
            background: AppColors.feedbackSuccessBg,
            border: AppColors.feedbackSuccessBorder,
            foreground: AppColors.feedbackSuccessText,
            icon: Icons.check_circle_outline_rounded,
          ),
        AppFeedbackVariant.info => const _FullWidthSpec(
            background: AppColors.feedbackSuccessBg,
            border: AppColors.feedbackSuccessBorder,
            foreground: AppColors.feedbackSuccessText,
            icon: Icons.info_outline_rounded,
          ),
        _ => const _FullWidthSpec(
            background: AppColors.feedbackErrorBg,
            border: AppColors.feedbackErrorBorder,
            foreground: AppColors.feedbackErrorText,
            icon: Icons.info_outline_rounded,
          ),
      };
}

class _CompactSpec {
  const _CompactSpec({
    required this.designWidth,
    required this.background,
    required this.foreground,
    required this.icon,
    required this.iconSize,
    required this.fontSize,
    required this.lineHeight,
    this.border,
  });

  final double designWidth;
  final Color background;
  final Color? border;
  final Color foreground;
  final IconData icon;
  final double iconSize;
  final double fontSize;
  final double lineHeight;
}

class _FullWidthSpec {
  const _FullWidthSpec({
    required this.background,
    required this.border,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final IconData icon;
}
