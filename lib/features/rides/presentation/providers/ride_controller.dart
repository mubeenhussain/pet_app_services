import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/firebase_service.dart';

class RideDraft {
  const RideDraft({
    this.petId,
    this.pickup,
    this.destination,
    this.carType = 'any',
    this.fareAmount,
    this.rideId,
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
    this.distanceKm,
  });

  final String? petId;
  final String? pickup;
  final String? destination;
  final String carType;
  final double? fareAmount;
  final String? rideId;
  final double? pickupLat;
  final double? pickupLng;
  final double? destinationLat;
  final double? destinationLng;
  final double? distanceKm;

  RideDraft copyWith({
    String? petId,
    String? pickup,
    String? destination,
    String? carType,
    double? fareAmount,
    String? rideId,
    double? pickupLat,
    double? pickupLng,
    double? destinationLat,
    double? destinationLng,
    double? distanceKm,
  }) {
    return RideDraft(
      petId: petId ?? this.petId,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      carType: carType ?? this.carType,
      fareAmount: fareAmount ?? this.fareAmount,
      rideId: rideId ?? this.rideId,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

final rideDraftProvider = StateProvider<RideDraft>((ref) => const RideDraft());

final rideControllerProvider =
    StateNotifierProvider<RideController, AsyncValue<void>>((ref) {
  return RideController(ref);
});

class RideController extends StateNotifier<AsyncValue<void>> {
  RideController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<double> loadFare(RideDraft draft) async {
    final distance = draft.distanceKm ?? 5.0;
    final durationMin = (distance / 30) * 60;
    final fare = await _ref.read(fareServiceProvider).calculateFare(
          distanceKm: distance,
          durationMin: durationMin,
        );
    _ref.read(rideDraftProvider.notifier).state =
        draft.copyWith(fareAmount: fare);
    return fare;
  }

  Future<RideModel?> submitRequest({
    required String userId,
    required RideRequestDto dto,
  }) async {
    state = const AsyncLoading();
    RideModel? ride;
    state = await AsyncValue.guard(() async {
      ride = await _ref.read(ridesRepositoryProvider).createRide(userId, dto);
      _ref.read(rideDraftProvider.notifier).state =
          _ref.read(rideDraftProvider).copyWith(rideId: ride!.id);
    });
    return ride;
  }
}
