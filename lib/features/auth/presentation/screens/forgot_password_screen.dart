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

/// BRD 6.6 — Forgot Password
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref
        .read(authControllerProvider.notifier)
        .resetPassword(_emailController.text.trim());

    if (!mounted) return;
    context.showAppSnackBar('Password reset email sent.');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return AuthShell(
      showBack: true,
      title: context.l10n.forgotPassword,
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => Validators.requiredField(v, field: 'Email'),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: context.l10n.submit,
            isLoading: isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
