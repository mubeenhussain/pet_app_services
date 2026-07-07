import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// A soft, rounded tile with a tinted background and border, used to frame a
/// feature icon (e.g. the mailbox on the OTP screen).
///
/// Purely presentational — pass any [child] (an [Image] or [Icon]).
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.child,
    this.size = 72,
  });

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }
}
