import 'package:flutter/material.dart';

/// Mailbox envelope icon used on the OTP verification screen.
class MailboxGlyph extends StatelessWidget {
  const MailboxGlyph({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/mailbox.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
