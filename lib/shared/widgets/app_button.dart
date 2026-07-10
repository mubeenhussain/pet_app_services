import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingLabel;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loaderColor =
        variant == AppButtonVariant.outlined ? scheme.primary : scheme.onPrimary;

    final Widget child;
    if (isLoading) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: AppLoadingMetrics.spinnerSizeMedium,
            width: AppLoadingMetrics.spinnerSizeMedium,
            child: AppLoadingSpinner(
              size: AppLoadingMetrics.spinnerSizeMedium,
              color: loaderColor,
              backgroundColor: loaderColor.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(width: AppLoadingMetrics.inlineGap),
          Text(loadingLabel ?? label),
        ],
      );
    } else {
      child = Text(label);
    }

    if (variant == AppButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}

/// Primary green action button with Figma loading style (SAVING — EDIT PET).
class AppPrimaryLoadingButton extends StatelessWidget {
  const AppPrimaryLoadingButton({
    super.key,
    required this.label,
    required this.loadingLabel,
    required this.onPressed,
    this.isLoading = false,
    this.height = 46,
  });

  final String label;
  final String loadingLabel;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? AppInlineLoadingRow(
                label: loadingLabel,
                spinnerSize: AppLoadingMetrics.spinnerSizeMedium,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                spinnerColor: Colors.white,
                spinnerTrackColor: Colors.white.withValues(alpha: 0.25),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

enum AppButtonVariant { primary, outlined }
