import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// A horizontal divider with a centered label, e.g. "OR CONTINUE WITH".
class LabeledDivider extends StatelessWidget {
  const LabeledDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmall?.copyWith(
      color: context.colors.textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      height: 1,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _Line(color: context.colors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(label.toUpperCase(), style: style),
        ),
        Expanded(child: _Line(color: context.colors.divider)),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}
