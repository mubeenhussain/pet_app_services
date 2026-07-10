import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// OTP resend countdown inside a green feedback container (Figma COUNTDOWN — OTP).
class AppCountdownBanner extends StatefulWidget {
  const AppCountdownBanner({
    super.key,
    required this.duration,
    required this.onResend,
    this.enabled = true,
  });

  final Duration duration;
  final Future<void> Function() onResend;
  final bool enabled;

  @override
  State<AppCountdownBanner> createState() => _AppCountdownBannerState();
}

class _AppCountdownBannerState extends State<AppCountdownBanner> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _remaining = widget.duration.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  String get _formatted {
    final minutes = (_remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleResend() async {
    await widget.onResend();
    if (mounted) _start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canResend = _remaining == 0 && widget.enabled;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.feedbackSuccessBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.feedbackSuccessBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: canResend ? _handleResend : null,
              child: Text(
                l10n.resendOtp,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: canResend
                      ? AppColors.feedbackSuccessText
                      : AppColors.textMuted,
                ),
              ),
            ),
          ),
          Text(
            _formatted,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.feedbackSuccessText,
            ),
          ),
        ],
      ),
    );
  }
}
