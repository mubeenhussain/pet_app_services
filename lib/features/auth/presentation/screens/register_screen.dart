import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/phone_field.dart';

/// BRD 6.4 — Register Page (phone + password, then OTP verify)
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToOtp(String phone) {
    context.push(
      '${RouteNames.otp}?phone=${Uri.encodeComponent(phone)}&flow=register',
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final controller = ref.read(authControllerProvider.notifier);

    await controller.sendRegisterOtp(phone);

    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    // OTP send failure (e.g. Firebase not configured yet) still advances the
    // flow so the UI can be exercised end-to-end during development.
    state.whenOrNull(
      error: (error, _) {
        context.showAppSnackBar(
          controller.mapError(error) ?? context.l10n.errorGeneric,
          isError: true,
        );
        _goToOtp(phone);
      },
      data: (_) => _goToOtp(phone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return AuthShell(
      showBack: true,
      title: l10n.registerTitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              controller: _usernameController,
              label: l10n.usernameHint,
              validator: Validators.username,
            ),
            const SizedBox(height: 16),
            PhoneField(
              controller: _phoneController,
              label: l10n.phoneHint,
              hint: '5X XXX XXXX',
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _cityController,
              label: l10n.cityHint,
              validator: (v) => Validators.requiredField(v, field: 'City'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: l10n.passwordHint,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: l10n.submit,
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
