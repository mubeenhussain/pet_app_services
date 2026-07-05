import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/widgets/app_button.dart';

/// BRD 6.26 — Payment Failure
class PaymentFailureScreen extends ConsumerWidget {
  const PaymentFailureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Theme.of(context).colorScheme.error, size: 80),
            const SizedBox(height: 16),
            Text(context.l10n.paymentFailed),
            const SizedBox(height: 32),
            AppButton(
              label: context.l10n.tryAgain,
              onPressed: () => context.go(RouteNames.checkout),
            ),
          ],
        ),
      ),
    );
  }
}
