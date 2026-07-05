class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.transactionId,
    this.message,
  });

  final bool success;
  final String transactionId;
  final String? message;
}

/// Abstraction for Moyasar / Tap (BRD Section 19 Open Q#1).
abstract class PaymentService {
  Future<PaymentResult> charge({
    required int amountHalalas,
    required String currency,
    required String idempotencyKey,
    required String description,
  });
}

class MockPaymentService implements PaymentService {
  @override
  Future<PaymentResult> charge({
    required int amountHalalas,
    required String currency,
    required String idempotencyKey,
    required String description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return PaymentResult(
      success: true,
      transactionId: 'mock_txn_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class PaymentServiceFactory {
  static PaymentService create() {
    // Gateway: AppConfig.instance.paymentGateway (moyasar | tap)
    return MockPaymentService();
  }
}
