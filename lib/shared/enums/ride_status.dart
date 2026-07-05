enum RideStatus {
  requested('requested'),
  driverAllocated('driver_allocated'),
  inProgress('in_progress'),
  delivered('delivered'),
  cancelled('cancelled');

  const RideStatus(this.value);

  final String value;

  static RideStatus fromValue(String value) {
    return RideStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => RideStatus.requested,
    );
  }

  String get label => switch (this) {
        RideStatus.requested => 'Requested',
        RideStatus.driverAllocated => 'Driver Allocated',
        RideStatus.inProgress => 'In Progress',
        RideStatus.delivered => 'Delivered',
        RideStatus.cancelled => 'Cancelled',
      };
}
