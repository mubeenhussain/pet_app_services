enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  refunded('refunded');

  const PaymentStatus(this.value);

  final String value;

  static PaymentStatus fromValue(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

enum VerificationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const VerificationStatus(this.value);

  final String value;

  static VerificationStatus fromValue(String value) {
    return VerificationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => VerificationStatus.pending,
    );
  }
}
