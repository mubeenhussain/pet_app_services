import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// Phone input with a leading country dial-code prefix.
///
/// Defaults to Saudi Arabia (+966) per BRD; override [flag]/[dialCode]
/// to reuse for other markets.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.flag = '🇸🇦',
    this.dialCode = '+966',
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final String flag;
  final String dialCode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      prefixIcon: _CountryPrefix(flag: flag, dialCode: dialCode),
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix({required this.flag, required this.dialCode});

  final String flag;
  final String dialCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            dialCode,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 22,
            color: context.colors.border,
          ),
        ],
      ),
    );
  }
}
