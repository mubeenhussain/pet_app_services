import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// BRD 6.34 — Ride Request Page
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

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_selectedPetId == null ||
        Validators.requiredField(_pickupController.text, field: 'Pickup') !=
            null ||
        Validators.requiredField(_destinationController.text, field: 'Destination') !=
            null) {
      context.showAppSnackBar('Please fill all fields and select a pet.', isError: true);
      return;
    }

    ref.read(rideDraftProvider.notifier).state = RideDraft(
      petId: _selectedPetId,
      pickup: _pickupController.text.trim(),
      destination: _destinationController.text.trim(),
      carType: _carType,
      fareAmount: 45.0,
    );
    context.push(RouteNames.rideReview);
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.requestRide)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _pickupController,
              label: context.l10n.pickup,
              validator: (v) => Validators.requiredField(v, field: 'Pickup'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _destinationController,
              label: context.l10n.destination,
              validator: (v) => Validators.requiredField(v, field: 'Destination'),
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
                decoration: const InputDecoration(hintText: 'Choose pet'),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Could not load pets'),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'any', label: Text('Any car')),
                ButtonSegment(value: 'specific', label: Text('Specific')),
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
