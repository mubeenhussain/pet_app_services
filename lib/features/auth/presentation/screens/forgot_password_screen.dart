import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';
import 'package:pet_app/shared/widgets/app_icon_badge.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/auth_text_link.dart';
import 'package:pet_app/shared/widgets/phone_field.dart';

/// BRD 6.6 — Forgot Password (phone → OTP reset flow)
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _goToOtp(String phone) {
    final normalized = PhoneAuthService.normalizePhone(phone);
    context.push(
      '${RouteNames.otp}?phone=${Uri.encodeComponent(normalized)}&flow=reset',
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);
    final phone = _phoneController.text.trim();
    final controller = ref.read(authControllerProvider.notifier);

    await controller.sendResetOtp(phone);

    if (!mounted) return;
    ref.read(authControllerProvider).whenOrNull(
          error: (error, _) {
            setState(
              () => _errorMessage =
                  controller.mapError(error) ?? context.l10n.noAccountFound,
            );
            _goToOtp(phone);
          },
          data: (_) {
            context.showAppSnackBar(context.l10n.resetCodeSent, isSuccess: true);
            _goToOtp(phone);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return AuthShell(
      circleBack: true,
      header: const AppIconBadge(child: Icon(Icons.vpn_key_outlined, size: 28)),
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      footer: AuthTextLink(
        label: l10n.backToLogin,
        icon: Icons.chevron_left,
        onTap: () => context.go(RouteNames.login),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              AppFeedbackBanner(message: _errorMessage!),
              const SizedBox(height: 16),
            ],
            PhoneField(
              controller: _phoneController,
              label: l10n.phoneHint,
              hint: l10n.phoneExample,
              validator: Validators.phone(context.l10n),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: l10n.sendOtp,
              loadingLabel: l10n.signingIn,
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
