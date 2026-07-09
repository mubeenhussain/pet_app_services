import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/enums/ride_status.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.40 — Delivery Confirmation
class RideDeliveryConfirmScreen extends ConsumerWidget {
  const RideDeliveryConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideId = ref.watch(rideDraftProvider).rideId;

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.deliveryConfirmed)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: context.colors.success, size: 72),
            const SizedBox(height: 16),
            Text(context.l10n.deliveryConfirmed),
            const Spacer(),
            AppButton(
              label: context.l10n.confirmDelivery,
              onPressed: () async {
                if (rideId != null) {
                  await ref.read(ridesRepositoryProvider).updateRideStatus(
                        rideId,
                        RideStatus.delivered.value,
                      );
                }
                if (context.mounted) context.go(RouteNames.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
