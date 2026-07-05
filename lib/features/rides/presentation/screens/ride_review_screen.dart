import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';

/// BRD 6.35 — Delivery Path Review
class RideReviewScreen extends ConsumerWidget {
  const RideReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(rideDraftProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Route & fare')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${draft.pickup ?? '-'}'),
                    const SizedBox(height: 8),
                    Text('To: ${draft.destination ?? '-'}'),
                    const Divider(height: 24),
                    Text(
                      'Estimated fare: SAR ${draft.fareAmount?.toStringAsFixed(2) ?? '--'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fare computed server-side in production (calculateFare Cloud Function).',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.continueLabel,
              onPressed: () => context.push(RouteNames.ridePayment),
            ),
          ],
        ),
      ),
    );
  }
}
