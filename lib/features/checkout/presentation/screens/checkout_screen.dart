import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/services/payment_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.24 — Checkout
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.checkout)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: context.l10n.deliveryAddress),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(context.l10n.mada),
              trailing: Icon(Icons.check_circle, color: context.colors.success),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.confirmAndPay,
              onPressed: () async {
                final result = await PaymentServiceFactory.create().charge(
                  amountHalalas: 4500,
                  currency: 'SAR',
                  idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: context.l10n.petServiceCheckout,
                );
                if (!context.mounted) return;
                context.go(
                  result.success ? RouteNames.paymentSuccess : RouteNames.paymentFailure,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
