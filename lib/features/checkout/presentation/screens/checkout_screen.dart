import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/services/payment_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';

/// BRD 6.24 — Checkout
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.checkout)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Delivery address')),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('Mada'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.confirmAndPay,
              onPressed: () async {
                final result = await PaymentServiceFactory.create().charge(
                  amountHalalas: 4500,
                  currency: 'SAR',
                  idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: 'Pet service checkout',
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
