import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_redirect_prompt.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/google_glyph.dart';
import 'package:pet_app/shared/widgets/labeled_divider.dart';
import 'package:pet_app/shared/widgets/phone_field.dart';
import 'package:pet_app/shared/widgets/social_auth_button.dart';

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

  /// Runs an auth action then routes home on success or surfaces the error.
  Future<void> _runAuthAction(Future<void> Function() action) async {
    final controller = ref.read(authControllerProvider.notifier);
    await action();

    if (!mounted) return;
    ref.read(authControllerProvider).whenOrNull(
          error: (error, _) => context.showAppSnackBar(
            controller.mapError(error) ?? context.l10n.errorGeneric,
            isError: true,
          ),
          data: (_) => context.go(RouteNames.home),
        );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await _runAuthAction(
      () => ref.read(authControllerProvider.notifier).signInWithPhone(
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
          ),
    );
  }

  Future<void> _googleSignIn() {
    return _runAuthAction(
      ref.read(authControllerProvider.notifier).signInWithGoogle,
    );
  }

  Future<void> _continueAsGuest() async {
    await ref.read(authControllerProvider.notifier).skipAsGuest();
    if (mounted) context.go(RouteNames.home);
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
            PhoneField(
              controller: _phoneController,
              label: l10n.phoneHint,
              hint: '5X XXX XXXX',
              validator: Validators.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _passwordController,
              label: l10n.passwordHint,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              onSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => context.push(RouteNames.forgotPassword),
                child: Text(l10n.forgotPassword),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: l10n.signIn,
              isLoading: isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            LabeledDivider(label: l10n.orContinueWith),
            const SizedBox(height: 24),
            SocialAuthButton(
              label: l10n.signInWithGoogle,
              leading: const GoogleGlyph(),
              isLoading: isLoading,
              onPressed: _googleSignIn,
            ),
            const SizedBox(height: 20),
            AuthRedirectPrompt(
              prompt: l10n.noAccountPrompt,
              actionLabel: l10n.signUp,
              onAction: () => context.push(RouteNames.register),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: isLoading ? null : _continueAsGuest,
              child: Text(
                l10n.skipForNow,
                style: TextStyle(
                  color: context.colors.textMuted,
                  decoration: TextDecoration.underline,
                  decorationColor: context.colors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
