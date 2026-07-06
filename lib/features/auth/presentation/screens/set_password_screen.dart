import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';

/// BRD 6.3 — Set Password
class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      title: context.l10n.passwordHint,
      child: Column(
        children: [
          AppTextField(
            controller: _passwordController,
            label: 'New password',
            obscureText: true,
            validator: Validators.password,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _confirmController,
            label: 'Confirm password',
            obscureText: true,
            validator: (v) =>
                Validators.confirmPassword(v, _passwordController.text),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: context.l10n.save,
            onPressed: () => context.go(RouteNames.login),
          ),
        ],
      ),
    );
  }
}
