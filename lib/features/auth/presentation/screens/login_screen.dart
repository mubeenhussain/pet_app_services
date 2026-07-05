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

/// BRD 6.1 — Login (phone + password per BRD)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    await controller.signInWithPhone(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) => context.showAppSnackBar(
        controller.mapError(error) ?? context.l10n.errorGeneric,
        isError: true,
      ),
      data: (_) => context.go(RouteNames.home),
    );
  }

  Future<void> _googleSignIn() async {
    final controller = ref.read(authControllerProvider.notifier);
    await controller.signInWithGoogle();
    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) => context.showAppSnackBar(
        controller.mapError(error) ?? context.l10n.errorGeneric,
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
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _phoneController,
              label: l10n.phoneHint,
              hint: '+966501234567',
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: l10n.passwordHint,
              obscureText: true,
              validator: Validators.password,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(RouteNames.forgotPassword),
                child: Text(l10n.forgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: l10n.signIn,
              isLoading: isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l10n.signInWithGoogle,
              variant: AppButtonVariant.outlined,
              isLoading: isLoading,
              onPressed: _googleSignIn,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push(RouteNames.register),
              child: Text(l10n.signUp),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await ref.read(authControllerProvider.notifier).skipAsGuest();
                      if (context.mounted) context.go(RouteNames.home);
                    },
              child: Text(l10n.skipForNow),
            ),
          ],
        ),
      ),
    );
  }
}
