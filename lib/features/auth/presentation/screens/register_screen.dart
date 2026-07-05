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

/// BRD 6.4 — Register Page
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
          city: _cityController.text.trim(),
        );

    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) => context.showAppSnackBar(
        ref.read(authControllerProvider.notifier).mapError(error) ??
            context.l10n.errorGeneric,
        isError: true,
      ),
      data: (_) => context.go(RouteNames.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return AuthShell(
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
            AppTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => Validators.requiredField(v, field: 'Email'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _phoneController,
              label: l10n.phoneHint,
              keyboardType: TextInputType.phone,
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
