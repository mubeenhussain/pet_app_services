import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';
import 'package:pet_app/shared/widgets/app_map_view.dart';

/// BRD 6.35 — Delivery Path Review (map route + server fare)
class RideReviewScreen extends ConsumerStatefulWidget {
  const RideReviewScreen({super.key});

  @override
  ConsumerState<RideReviewScreen> createState() => _RideReviewScreenState();
}

class _RideReviewScreenState extends ConsumerState<RideReviewScreen> {
  var _loadingFare = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFare());
  }

  Future<void> _loadFare() async {
    final draft = ref.read(rideDraftProvider);
    await ref.read(rideControllerProvider.notifier).loadFare(draft);
    if (mounted) setState(() => _loadingFare = false);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(rideDraftProvider);
    final markers = <Marker>{};
    final polylines = <Polyline>{};

    if (draft.pickupLat != null && draft.pickupLng != null) {
      final pickup = LatLng(draft.pickupLat!, draft.pickupLng!);
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
      if (draft.destinationLat != null && draft.destinationLng != null) {
        final destination =
            LatLng(draft.destinationLat!, draft.destinationLng!);
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        );
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [pickup, destination],
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Route & fare')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppMapView(
              markers: markers,
              polylines: polylines,
              initialTarget: draft.pickupLat != null && draft.pickupLng != null
                  ? LatLng(draft.pickupLat!, draft.pickupLng!)
                  : null,
              height: 260,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${draft.pickup ?? '-'}'),
                    const SizedBox(height: 8),
                    Text('To: ${draft.destination ?? '-'}'),
                    if (draft.distanceKm != null) ...[
                      const SizedBox(height: 8),
                      Text('Distance: ${draft.distanceKm!.toStringAsFixed(1)} km'),
                    ],
                    const Divider(height: 24),
                    if (_loadingFare)
                      AppLoadingView(message: context.l10n.loading)
                    else
                      Text(
                        'Estimated fare: SAR ${draft.fareAmount?.toStringAsFixed(2) ?? '--'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Fare from calculateFare Cloud Function (server authoritative).',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.continueLabel,
              onPressed: _loadingFare ? null : () => context.push(RouteNames.ridePayment),
            ),
          ],
        ),
      ),
    );
  }
}
