import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/services/location_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:pet_app/shared/widgets/app_map_view.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// BRD 6.34 — Ride Request Page (with map pin selection)
class RideRequestScreen extends ConsumerStatefulWidget {
  const RideRequestScreen({super.key});

  @override
  ConsumerState<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends ConsumerState<RideRequestScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  String? _selectedPetId;
  String _carType = 'any';
  LatLng? _pickupLatLng;
  LatLng? _destinationLatLng;
  LatLng _mapCenter = LocationService.defaultLocation;
  bool _selectingDestination = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final l10n = context.l10n;
    final current = await LocationService.getCurrentLatLng();
    if (current != null && mounted) {
      setState(() {
        _mapCenter = current;
        _pickupLatLng = current;
        _destinationLatLng = LocationService.offsetDemo(current);
        _pickupController.text = l10n.currentLocation;
        _destinationController.text = l10n.selectedDestination;
      });
    } else {
      setState(() {
        _pickupLatLng = LocationService.defaultLocation;
        _destinationLatLng = LocationService.offsetDemo(_pickupLatLng!);
      });
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_selectedPetId == null ||
        _pickupLatLng == null ||
        _destinationLatLng == null ||
        Validators.requiredField(
              context.l10n,
              field: context.l10n.pickupShort,
            )(_pickupController.text) !=
            null) {
      context.showAppSnackBar(
        context.l10n.selectPickupDestPet,
        isError: true,
      );
      return;
    }

    final distanceKm = await LocationService.distanceKm(
      _pickupLatLng!,
      _destinationLatLng!,
    );

    ref.read(rideDraftProvider.notifier).state = RideDraft(
      petId: _selectedPetId,
      pickup: _pickupController.text.trim(),
      destination: _destinationController.text.trim(),
      carType: _carType,
      pickupLat: _pickupLatLng!.latitude,
      pickupLng: _pickupLatLng!.longitude,
      destinationLat: _destinationLatLng!.latitude,
      destinationLng: _destinationLatLng!.longitude,
      distanceKm: distanceKm,
    );
    context.push(RouteNames.rideReview);
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      if (_selectingDestination) {
        _destinationLatLng = latLng;
        _destinationController.text =
            '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
      } else {
        _pickupLatLng = latLng;
        _pickupController.text =
            '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
      }
    });
  }

  Set<Marker> get _markers {
    final markers = <Marker>{};
    if (_pickupLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLatLng!,
          infoWindow: InfoWindow(title: context.l10n.pickupShort),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (_destinationLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLatLng!,
          infoWindow: InfoWindow(title: context.l10n.destinationShort),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petsListProvider);

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.requestRide)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(context.l10n.setPickup)),
                ButtonSegment(
                  value: true,
                  label: Text(context.l10n.setDestination),
                ),
              ],
              selected: {_selectingDestination},
              onSelectionChanged: (v) =>
                  setState(() => _selectingDestination = v.first),
            ),
            const SizedBox(height: 12),
            AppMapView(
              markers: _markers,
              initialTarget: _mapCenter,
              onTap: _onMapTap,
              height: 240,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _pickupController,
              label: context.l10n.pickup,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _destinationController,
              label: context.l10n.destination,
            ),
            const SizedBox(height: 16),
            Text(context.l10n.selectPet),
            petsAsync.when(
              data: (pets) => DropdownButtonFormField<String>(
                value: _selectedPetId,
                items: pets
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPetId = v),
                decoration: InputDecoration(hintText: context.l10n.choosePet),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(context.l10n.couldNotLoadPets),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'any', label: Text(context.l10n.anyCar)),
                ButtonSegment(
                  value: 'specific',
                  label: Text(context.l10n.specificCar),
                ),
              ],
              selected: {_carType},
              onSelectionChanged: (v) => setState(() => _carType = v.first),
            ),
            const SizedBox(height: 24),
            AppButton(label: context.l10n.continueLabel, onPressed: _continue),
          ],
        ),
      ),
    );
  }
}
