import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/shared/enums/payment_status.dart';
import 'package:pet_app/shared/enums/ride_status.dart';
import 'package:pet_app/shared/models/ride_model.dart';

class RidesFirestoreDataSource {
  RidesFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _rides =>
      _firestore.collection('rides');

  Stream<RideModel?> watchRide(String rideId) {
    return _rides.doc(rideId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return RideModel.fromMap(doc.data()!, id: doc.id);
    });
  }

  Future<RideModel> createRide(String userId, RideRequestDto dto) async {
    final data = {
      ...dto.toMap(),
      'userId': userId,
      'status': RideStatus.requested.value,
      'paymentStatus': PaymentStatus.pending.value,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final doc = await _rides.add(data);
    return RideModel.fromMap(data, id: doc.id);
  }

  Future<void> updateRideStatus(String rideId, String status) async {
    await _rides.doc(rideId).update({'status': status});
  }

  Future<List<RideModel>> getUserRides(String userId) async {
    final snapshot = await _rides
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => RideModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }
}
