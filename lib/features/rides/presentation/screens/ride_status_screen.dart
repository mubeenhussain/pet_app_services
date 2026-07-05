import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/enums/ride_status.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

/// BRD 6.39 — Ride Status
class RideStatusScreen extends ConsumerWidget {
  const RideStatusScreen({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideAsync = ref.watch(_rideProvider(rideId));

    return Scaffold(
      appBar: AppBar(title: const Text('Ride status')),
      body: rideAsync.when(
        loading: () => AppLoadingView(message: context.l10n.loading),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (ride) {
          if (ride == null) return const Center(child: Text('Ride not found'));
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...RideStatus.values.map(
                  (status) => ListTile(
                    leading: Icon(
                      ride.status.index >= status.index
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                    title: Text(status.label),
                  ),
                ),
                const Spacer(),
                AppButton(
                  label: context.l10n.deliveryConfirmed,
                  onPressed: () => context.push(RouteNames.rideDeliveryConfirm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final _rideProvider = StreamProvider.autoDispose.family(
  (ref, String rideId) => ref.watch(ridesRepositoryProvider).watchRide(rideId),
);
