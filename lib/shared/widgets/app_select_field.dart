import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/widgets/field_label.dart';

/// A themed dropdown that visually matches [AppTextField].
///
/// Generic over the option type [T]; renders each option via [itemLabel].
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.label,
    this.optionalLabel = false,
    this.hint,
  });

  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final bool optionalLabel;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final field = DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.textMuted,
      ),
      hint: hint == null
          ? null
          : Text(
              hint!,
              style: TextStyle(
                color: context.colors.textMuted.withValues(alpha: 0.9),
              ),
            ),
      items: [
        for (final item in items)
          DropdownMenuItem<T>(value: item, child: Text(itemLabel(item))),
      ],
      onChanged: onChanged,
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label!, optional: optionalLabel),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
