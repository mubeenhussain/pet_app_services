import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  return FirebaseFunctions.instance;
});

final fareServiceProvider = Provider<FareService>((ref) {
  return FareService(ref.watch(cloudFunctionsProvider));
});

class FareService {
  FareService(this._functions);

  final FirebaseFunctions _functions;

  Future<double> calculateFare({
    required double distanceKm,
    required double durationMin,
  }) async {
    try {
      final callable = _functions.httpsCallable('calculateFare');
      final result = await callable.call<Map<String, dynamic>>({
        'distanceKm': distanceKm,
        'durationMin': durationMin,
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      return (data['fareAmount'] as num).toDouble();
    } catch (e) {
      debugPrint('calculateFare fallback: $e');
      return 25 + distanceKm * 3.5 + durationMin * 0.5;
    }
  }
}

/// Android emulator reaches host machine via 10.0.2.2, not localhost.
String get firebaseEmulatorHost {
  if (kIsWeb) return 'localhost';
  if (Platform.isAndroid) return '10.0.2.2';
  return 'localhost';
}
