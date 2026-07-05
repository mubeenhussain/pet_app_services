import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';

/// BRD 6.2 — OTP Confirmation (placeholder until Phone Auth is configured)
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthShell(
      title: l10n.otpTitle,
      subtitle: l10n.otpSubtitle(widget.phone),
      child: Column(
        children: [
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(hintText: '000000'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.confirm,
            onPressed: () {
              if (widget.flow == 'reset') {
                context.push(RouteNames.setPassword);
              } else {
                context.go(RouteNames.home);
              }
            },
          ),
          TextButton(
            onPressed: () {},
            child: Text(l10n.resendOtp),
          ),
        ],
      ),
    );
  }
}
