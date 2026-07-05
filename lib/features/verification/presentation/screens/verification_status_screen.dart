import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// BRD 6.54 — Verification Status
class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.verificationPending)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_top, size: 56),
            const SizedBox(height: 16),
            Text(context.l10n.verificationPending),
          ],
        ),
      ),
    );
  }
}
