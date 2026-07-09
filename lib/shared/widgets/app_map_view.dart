import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_app/core/config/maps_config.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

class AppMapView extends StatelessWidget {
  const AppMapView({
    super.key,
    required this.markers,
    this.polylines = const {},
    this.onTap,
    this.initialTarget,
    this.height = 220,
  });

  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final void Function(LatLng)? onTap;
  final LatLng? initialTarget;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (!MapsConfig.isConfigured) {
      return Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.l10n.mapsApiKeyMissing,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final target = initialTarget ?? MapsConfig.defaultLocation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 12),
          markers: markers,
          polylines: polylines,
          onTap: onTap,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}
