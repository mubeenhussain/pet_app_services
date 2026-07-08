import 'package:flutter/foundation.dart';

enum AppFlavor { consumer, admin }

enum AppEnvironment { dev, staging, prod }

enum PaymentGateway { moyasar, tap }

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.flavor,
    required this.paymentGateway,
    required this.useFirebaseEmulator,
    required this.apiBaseUrl,
  });

  final AppEnvironment environment;
  final AppFlavor flavor;
  final PaymentGateway paymentGateway;
  final bool useFirebaseEmulator;
  final String apiBaseUrl;

  bool get isAdmin => flavor == AppFlavor.admin;
  bool get isConsumer => flavor == AppFlavor.consumer;
  bool get isDev => environment == AppEnvironment.dev;

  /// Skip Firebase Phone Auth and accept [AppConstants.fakeOtpCode].
  /// Enabled for all debug builds so OTP works without Phone Auth setup.
  bool get useFakeOtp => isDev || kDebugMode;

  static AppConfig? _instance;

  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('AppConfig not initialized. Call AppConfig.init() first.');
    }
    return config;
  }

  static void init({
    AppEnvironment environment = AppEnvironment.dev,
    AppFlavor flavor = AppFlavor.consumer,
    PaymentGateway paymentGateway = PaymentGateway.moyasar,
    bool useFirebaseEmulator = true,
    String apiBaseUrl = '',
  }) {
    _instance = AppConfig(
      environment: environment,
      flavor: flavor,
      paymentGateway: paymentGateway,
      useFirebaseEmulator: useFirebaseEmulator,
      apiBaseUrl: apiBaseUrl,
    );
  }
}
