import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Figma loading metrics — shared across list footers, full-screen, and buttons.
abstract final class AppLoadingMetrics {
  AppLoadingMetrics._();

  static const spinnerSizeSmall = 18.0;
  static const spinnerSizeMedium = 20.0;
  static const spinnerSizeLarge = 24.0;
  static const strokeWidth = 2.0;
  static const inlineGap = 8.0;
  static const stackGap = 12.0;

  static const arcColor = Color(0xFF12201A);
  static const trackColor = AppColors.skeleton;

  static const inlineTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );
}

/// Circular spinner used for inline and full-screen loading states.
class AppLoadingSpinner extends StatelessWidget {
  const AppLoadingSpinner({
    super.key,
    this.size = AppLoadingMetrics.spinnerSizeSmall,
    this.color,
    this.backgroundColor,
  });

  final double size;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: AppLoadingMetrics.strokeWidth,
        color: color ?? AppLoadingMetrics.arcColor,
        backgroundColor: backgroundColor ?? AppLoadingMetrics.trackColor,
      ),
    );
  }
}

/// Figma — horizontal "Loading more..." row (pagination / list footer).
class AppLoadingMore extends StatelessWidget {
  const AppLoadingMore({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AppInlineLoadingRow(
      label: message ?? context.l10n.loadingMore,
    );
  }
}

/// Horizontal spinner + label row for inline loading states.
class AppInlineLoadingRow extends StatelessWidget {
  const AppInlineLoadingRow({
    super.key,
    required this.label,
    this.spinnerSize = AppLoadingMetrics.spinnerSizeSmall,
    this.textStyle = AppLoadingMetrics.inlineTextStyle,
    this.gap = AppLoadingMetrics.inlineGap,
    this.spinnerColor,
    this.spinnerTrackColor,
  });

  final String label;
  final double spinnerSize;
  final TextStyle textStyle;
  final double gap;
  final Color? spinnerColor;
  final Color? spinnerTrackColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLoadingSpinner(
          size: spinnerSize,
          color: spinnerColor,
          backgroundColor: spinnerTrackColor,
        ),
        SizedBox(width: gap),
        Text(label, style: textStyle),
      ],
    );
  }
}

/// Full-screen / section loading with optional message below the spinner.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return const Center(
        child: AppLoadingSpinner(size: AppLoadingMetrics.spinnerSizeLarge),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoadingSpinner(size: AppLoadingMetrics.spinnerSizeLarge),
          const SizedBox(height: AppLoadingMetrics.stackGap),
          Text(
            message!,
            style: AppLoadingMetrics.inlineTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
