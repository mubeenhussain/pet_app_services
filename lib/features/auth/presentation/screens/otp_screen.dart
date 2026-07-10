import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/config/app_config.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/phone_formatter.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_countdown_banner.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';
import 'package:pet_app/shared/widgets/app_icon_badge.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/mailbox_glyph.dart';
import 'package:pet_app/shared/widgets/otp_input_field.dart';

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
  String _otp = '';
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Restore OTP challenge from local storage if memory state was lost.
    Future.microtask(_restoreOtpSession);
  }

  Future<void> _restoreOtpSession() async {
    final memory = ref.read(phoneAuthSessionProvider);
    if (memory != null) return;

    final storage = ref.read(localStorageProvider);
    final stored = await storage.readPendingOtpSession();
    if (!mounted) return;

    if (stored != null) {
      ref.read(phoneAuthSessionProvider.notifier).state = stored.session;
      return;
    }

    if (AppConfig.instance.useFakeOtp) {
      const session = PhoneAuthSession(
        verificationId: AppConstants.fakeOtpVerificationId,
      );
      ref.read(phoneAuthSessionProvider.notifier).state = session;
      await storage.savePendingOtpSession(
        session: session,
        phone: widget.phone,
        flow: widget.flow,
      );
    }
  }

  Future<void> _confirm() async {
    if (_otp.length != AppConstants.otpLength) {
      setState(() => _errorMessage = context.l10n.otpInvalid(AppConstants.otpLength));
      return;
    }

    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    final controller = ref.read(authControllerProvider.notifier);

    if (widget.flow == 'register') {
      await controller.confirmPhoneOtp(_otp, phone: widget.phone);
    } else {
      context.push(RouteNames.setPassword);
      return;
    }

    if (!mounted) return;
    ref.read(authControllerProvider).whenOrNull(
          error: (error, _) => setState(
            () => _errorMessage =
                controller.mapError(error) ?? context.l10n.errorGeneric,
          ),
          data: (_) {
            final name = ref.read(currentUserProvider)?.username ?? '';
            final displayName = name.trim().isEmpty
                ? context.l10n.guestUser
                : name.trim().split(RegExp(r'\s+')).first;
            setState(
              () => _successMessage =
                  context.l10n.welcomeBackUser(displayName),
            );
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (mounted) context.go(RouteNames.home);
            });
          },
        );
  }

  Future<void> _resend() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });
    await ref.read(authControllerProvider.notifier).sendRegisterOtp(widget.phone);
    if (mounted) {
      context.showAppSnackBar(context.l10n.otpResent, isSuccess: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;
    final maskedPhone = PhoneFormatter.mask(widget.phone);

    return AuthShell(
      circleBack: true,
      alignTop: true,
      header: const AppIconBadge(child: MailboxGlyph()),
      title: l10n.otpTitle,
      subtitleWidget: Column(
        children: [
          Text(
            l10n.otpInstruction(AppConstants.otpLength),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            maskedPhone,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (AppConfig.instance.useFakeOtp) ...[
            const SizedBox(height: 8),
            Text(
              l10n.devOtp(AppConstants.fakeOtpCode),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_successMessage != null) ...[
            AppFeedbackBanner(
              message: _successMessage!,
              variant: AppFeedbackVariant.success,
            ),
            const SizedBox(height: 16),
          ],
          if (_errorMessage != null) ...[
            AppFeedbackBanner(message: _errorMessage!),
            const SizedBox(height: 16),
          ],
          OtpInputField(
            length: AppConstants.otpLength,
            onChanged: (value) => setState(() => _otp = value),
            onCompleted: (_) => _confirm(),
          ),
          const SizedBox(height: 20),
          AppCountdownBanner(
            duration: const Duration(seconds: 47),
            enabled: !isLoading,
            onResend: _resend,
          ),
          const SizedBox(height: 28),
          AppButton(
            label: l10n.confirm,
            loadingLabel: l10n.signingIn,
            isLoading: isLoading,
            onPressed: _confirm,
          ),
        ],
      ),
    );
  }
}
