import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

/// Outlined button for third-party sign-in (Google, Apple, etc.).
///
/// [leading] sits on the left; [label] stays centered — matching common
/// social-auth button layouts in design specs.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: scheme.surface,
        disabledBackgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: context.colors.border),
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: isLoading
          ? AppLoadingSpinner(
              size: AppLoadingMetrics.spinnerSizeMedium,
              color: scheme.primary,
              backgroundColor: scheme.primary.withValues(alpha: 0.15),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                leading,
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}
