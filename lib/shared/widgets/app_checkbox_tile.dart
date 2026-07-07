import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// A compact checkbox followed by a tappable [label] widget (usually rich
/// text with an inline link). Purely presentational — state is owned by parent.
class AppCheckboxTile extends StatelessWidget {
  const AppCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: BorderSide(color: context.colors.border, width: 1.5),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(child: label),
      ],
    );
  }
}
