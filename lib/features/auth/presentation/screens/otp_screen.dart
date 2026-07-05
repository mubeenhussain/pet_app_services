import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';

/// BRD 6.2 — OTP Confirmation (Firebase Phone Auth)
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.phone,
    required this.flow,
  });

  final String phone;
  final String flow;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final code = _otpController.text.trim();
    if (code.length != AppConstants.otpLength) {
      context.showAppSnackBar(
        'Enter ${AppConstants.otpLength}-digit code',
        isError: true,
      );
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);

    if (widget.flow == 'register') {
      await controller.confirmPhoneOtp(code);
    } else {
      context.push(RouteNames.setPassword);
      return;
    }

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

  Future<void> _resend() async {
    await ref.read(authControllerProvider.notifier).sendRegisterOtp(widget.phone);
    if (mounted) context.showAppSnackBar('OTP resent.');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return AuthShell(
      title: l10n.otpTitle,
      subtitle: l10n.otpSubtitle(widget.phone),
      child: Column(
        children: [
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: AppConstants.otpLength,
            decoration: const InputDecoration(hintText: '000000'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.confirm,
            isLoading: isLoading,
            onPressed: _confirm,
          ),
          TextButton(
            onPressed: isLoading ? null : _resend,
            child: Text(l10n.resendOtp),
          ),
        ],
      ),
    );
  }
}
