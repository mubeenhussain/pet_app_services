import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// Bold field label rendered above form inputs, with an optional muted
/// "(optional)" suffix.
class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.label,
    this.optional = false,
  });

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textTheme.titleMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: context.colorScheme.onSurface,
    );

    if (!optional) return Text(label, style: baseStyle);

    return Text.rich(
      TextSpan(
        text: '$label ',
        style: baseStyle,
        children: [
          TextSpan(
            text: '(${context.l10n.optional})',
            style: baseStyle?.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
