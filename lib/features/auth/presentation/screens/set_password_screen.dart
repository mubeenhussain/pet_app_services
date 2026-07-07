import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_icon_badge.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/password_strength_meter.dart';

/// BRD 6.3 — Set Password
class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _password = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(
      () => setState(() => _password = _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthShell(
      circleBack: true,
      header: const AppIconBadge(child: Icon(Icons.lock_outline, size: 28)),
      title: l10n.setPasswordTitle,
      subtitle: l10n.setPasswordSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _passwordController,
              label: l10n.newPassword,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
            ),
            const SizedBox(height: 12),
            PasswordStrengthMeter(password: _password),
            const SizedBox(height: 20),
            AppTextField(
              controller: _confirmController,
              label: l10n.confirmPassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  Validators.confirmPassword(v, _passwordController.text),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: l10n.changePassword,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
