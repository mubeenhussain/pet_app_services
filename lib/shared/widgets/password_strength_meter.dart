import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/utils/password_strength.dart';

/// Segmented strength meter with a trailing label, driven by [password].
///
/// Colors are resolved from the theme so it stays consistent app-wide.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.segments = 4,
  });

  final String password;
  final int segments;

  int _filledCount(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return segments;
    }
  }

  Color _color(BuildContext context, PasswordStrength strength) {
    final scheme = context.colorScheme;
    switch (strength) {
      case PasswordStrength.empty:
      case PasswordStrength.weak:
        return scheme.error;
      case PasswordStrength.fair:
        return scheme.secondary;
      case PasswordStrength.good:
        return scheme.primary;
      case PasswordStrength.strong:
        return context.colors.primaryDark;
    }
  }

  String _label(BuildContext context, PasswordStrength strength) {
    final l10n = context.l10n;
    switch (strength) {
      case PasswordStrength.empty:
      case PasswordStrength.weak:
        return l10n.strengthWeak;
      case PasswordStrength.fair:
        return l10n.strengthFair;
      case PasswordStrength.good:
        return l10n.strengthGood;
      case PasswordStrength.strong:
        return l10n.strengthStrong;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = PasswordStrengthEvaluator.evaluate(password);
    final filled = _filledCount(strength);
    final color = _color(context, strength);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(segments, (i) {
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: i == segments - 1 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: i < filled
                        ? color
                        : context.colors.divider,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
        if (strength != PasswordStrength.empty) ...[
          const SizedBox(width: 12),
          Text(
            _label(context, strength),
            style: context.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
