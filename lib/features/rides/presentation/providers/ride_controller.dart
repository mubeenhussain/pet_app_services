import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

class RideDraft {
  const RideDraft({
    this.petId,
    this.pickup,
    this.destination,
    this.carType = 'any',
    this.fareAmount,
    this.rideId,
  });

  final String? petId;
  final String? pickup;
  final String? destination;
  final String carType;
  final double? fareAmount;
  final String? rideId;

  RideDraft copyWith({
    String? petId,
    String? pickup,
    String? destination,
    String? carType,
    double? fareAmount,
    String? rideId,
  }) {
    return RideDraft(
      petId: petId ?? this.petId,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      carType: carType ?? this.carType,
      fareAmount: fareAmount ?? this.fareAmount,
      rideId: rideId ?? this.rideId,
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
