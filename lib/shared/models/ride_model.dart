import 'package:equatable/equatable.dart';
import 'package:pet_app/shared/enums/payment_status.dart';
import 'package:pet_app/shared/enums/ride_status.dart';

class RideModel extends Equatable {
  const RideModel({
    required this.id,
    required this.userId,
    required this.petId,
    required this.status,
    required this.pickup,
    required this.destination,
    required this.carType,
    required this.paymentStatus,
    this.driverId,
    this.fareAmount,
    this.paymentTxnId,
    this.allocatedBy,
    this.cancellationReason,
    this.createdAt,
    this.allocatedAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String? driverId;
  final String petId;
  final RideStatus status;
  final String pickup;
  final String destination;
  final String carType;
  final double? fareAmount;
  final PaymentStatus paymentStatus;
  final String? paymentTxnId;
  final String? allocatedBy;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? allocatedAt;
  final DateTime? completedAt;

  factory RideModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return RideModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      driverId: map['driverId'] as String?,
      petId: map['petId'] as String? ?? '',
      status: RideStatus.fromValue(map['status'] as String? ?? 'requested'),
      pickup: map['pickup'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      carType: map['carType'] as String? ?? 'any',
      fareAmount: (map['fareAmount'] as num?)?.toDouble(),
      paymentStatus: PaymentStatus.fromValue(
        map['paymentStatus'] as String? ?? 'pending',
      ),
      paymentTxnId: map['paymentTxnId'] as String?,
      allocatedBy: map['allocatedBy'] as String?,
      cancellationReason: map['cancellationReason'] as String?,
      createdAt: _parseDate(map['createdAt']),
      allocatedAt: _parseDate(map['allocatedAt']),
      completedAt: _parseDate(map['completedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'driverId': driverId,
      'petId': petId,
      'status': status.value,
      'pickup': pickup,
      'destination': destination,
      'carType': carType,
      'fareAmount': fareAmount,
      'paymentStatus': paymentStatus.value,
      'paymentTxnId': paymentTxnId,
      'allocatedBy': allocatedBy,
      'cancellationReason': cancellationReason,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props => [id, status, paymentStatus];
}

class RideRequestDto extends Equatable {
  const RideRequestDto({
    required this.petId,
    required this.pickup,
    required this.destination,
    required this.carType,
  });

  final String petId;
  final String pickup;
  final String destination;
  final String carType;

  Map<String, dynamic> toMap() => {
        'petId': petId,
        'pickup': pickup,
        'destination': destination,
        'carType': carType,
      };

  @override
  List<Object?> get props => [petId, pickup, destination, carType];
}
