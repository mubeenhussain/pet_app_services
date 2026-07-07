import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// Circular back button used on auth screens (OTP, etc.).
///
/// Matches Figma: 40×40 white circle, light-green border, chevron icon.
class AuthCircleBackButton extends StatelessWidget {
  const AuthCircleBackButton({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: scheme.surface,
        shape: CircleBorder(side: BorderSide(color: context.colors.border)),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onBack ?? () => context.pop(),
          child: Icon(
            Icons.chevron_left,
            size: 22,
            color: scheme.primary,
          ),
        ),
      ),
    );
  }
}
