import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// Shows "Didn't get the code? Resend in mm:ss" while counting down, then
/// exposes a tappable "Resend" action that restarts the timer.
class ResendCountdown extends StatefulWidget {
  const ResendCountdown({
    super.key,
    required this.duration,
    required this.onResend,
    this.enabled = true,
  });

  final Duration duration;
  final Future<void> Function() onResend;
  final bool enabled;

  @override
  State<ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<ResendCountdown> {
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
    final mutedStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colors.textMuted,
    );
    final canResend = _remaining == 0 && widget.enabled;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${l10n.didntGetCode} ', style: mutedStyle),
        if (canResend)
          GestureDetector(
            onTap: _handleResend,
            child: Text(
              l10n.resend,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.link,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Text(
            l10n.resendIn(_formatted),
            style: mutedStyle?.copyWith(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
