import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/enums/ride_status.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/firebase_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 7.1 — Pending Driver Requests (allocateDriver Cloud Function)
class PendingDriverRequestsScreen extends ConsumerWidget {
  const PendingDriverRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(_pendingRidesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppTopBar(title: Text(l10n.pendingDriverRequests)),
      body: ridesAsync.when(
        loading: () => const AppLoadingView(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (rides) {
          if (rides.isEmpty) {
            return Center(child: Text(l10n.noPendingRideRequests));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${ride.pickup} → ${ride.destination}'),
                      Text(l10n.petLabel(ride.petId)),
                      Text(
                        l10n.rideFareLabel(
                          ride.fareAmount == null
                              ? '--'
                              : l10n.sarAmountFormatted(
                                  NumberFormat(
                                    '#,##0.00',
                                  ).format(ride.fareAmount),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        label: l10n.allocateDemoDriver,
                        onPressed: () => _allocate(ref, ride.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _allocate(WidgetRef ref, String rideId) async {
    try {
      final callable =
          ref.read(cloudFunctionsProvider).httpsCallable('allocateDriver');
      await callable.call({
        'rideId': rideId,
        'driverId': 'demo_driver_1',
      });
      ref.invalidate(_pendingRidesProvider);
    } catch (e) {
      // Fallback when emulator/functions not running — update Firestore directly.
      await ref.read(firestoreProvider).collection('rides').doc(rideId).update({
        'driverId': 'demo_driver_1',
        'status': RideStatus.driverAllocated.value,
        'allocatedAt': FieldValue.serverTimestamp(),
      });
      ref.invalidate(_pendingRidesProvider);
    }
  }
}

final _pendingRidesProvider = StreamProvider.autoDispose<List<RideModel>>((ref) {
  return ref.watch(firestoreProvider).collection('rides').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => RideModel.fromMap(doc.data(), id: doc.id))
            .where((r) => r.status == RideStatus.requested)
            .toList(),
      );
});
