import 'package:pet_app/shared/models/ride_model.dart';

abstract class RidesRepository {
  Stream<RideModel?> watchRide(String rideId);
  Future<RideModel> createRide(String userId, RideRequestDto dto);
  Future<void> updateRideStatus(String rideId, String status);
  Future<List<RideModel>> getUserRides(String userId);
}
