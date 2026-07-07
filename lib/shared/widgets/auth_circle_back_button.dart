import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// Circular back button used on auth screens (OTP, etc.).
class AuthCircleBackButton extends StatelessWidget {
  const AuthCircleBackButton({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        color: scheme.surface,
        shape: CircleBorder(side: BorderSide(color: context.colors.border)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onBack ?? () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.arrow_back,
              size: 20,
              color: scheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
