import 'package:pet_app/features/rides/data/datasources/rides_firestore_datasource.dart';
import 'package:pet_app/features/rides/domain/repositories/rides_repository.dart';
import 'package:pet_app/shared/models/ride_model.dart';

class RidesRepositoryImpl implements RidesRepository {
  RidesRepositoryImpl(this._dataSource);

  final RidesFirestoreDataSource _dataSource;

  @override
  Stream<RideModel?> watchRide(String rideId) => _dataSource.watchRide(rideId);

  @override
  Future<RideModel> createRide(String userId, RideRequestDto dto) =>
      _dataSource.createRide(userId, dto);

  @override
  Future<void> updateRideStatus(String rideId, String status) =>
      _dataSource.updateRideStatus(rideId, status);

  @override
  Future<List<RideModel>> getUserRides(String userId) =>
      _dataSource.getUserRides(userId);
}
