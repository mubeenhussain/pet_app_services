import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// A horizontal divider with a centered label, e.g. "OR CONTINUE WITH".
class LabeledDivider extends StatelessWidget {
  const LabeledDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmall?.copyWith(
      color: context.colors.textSecondary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label.toUpperCase(), style: style),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
