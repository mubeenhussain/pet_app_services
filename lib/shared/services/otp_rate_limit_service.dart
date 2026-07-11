import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/config/app_config.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/core/constants/storage_keys.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/firebase_service.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';

/// BRD — max 3 OTP requests per phone per 10 minutes.
class OtpRateLimitException implements Exception {
  OtpRateLimitException({required this.retryAfterMinutes});

  final int retryAfterMinutes;

  @override
  String toString() =>
      'OTP rate limit exceeded. Retry in $retryAfterMinutes minutes.';
}

class OtpRateLimitService {
  OtpRateLimitService({
    required LocalStorageService storage,
    required FirebaseFunctions functions,
  })  : _storage = storage,
        _functions = functions;

  final LocalStorageService _storage;
  final FirebaseFunctions _functions;

  Future<void> assertCanRequest(String phoneE164) async {
    if (AppConfig.instance.useFakeOtp) return;

    try {
      final callable = _functions.httpsCallable('assertOtpRateLimit');
      await callable.call<Map<String, dynamic>>({'phone': phoneE164});
      return;
    } catch (e) {
      debugPrint('assertOtpRateLimit fallback to local: $e');
    }

    await _assertLocal(phoneE164);
  }

  Future<void> recordRequest(String phoneE164) async {
    if (AppConfig.instance.useFakeOtp) return;

    try {
      final callable = _functions.httpsCallable('recordOtpRequest');
      await callable.call<Map<String, dynamic>>({'phone': phoneE164});
      return;
    } catch (e) {
      debugPrint('recordOtpRequest fallback to local: $e');
    }

    await _recordLocal(phoneE164);
  }

  Future<void> _assertLocal(String phoneE164) async {
    final attempts = await _readLocalAttempts(phoneE164);
    if (attempts.length >= AppConstants.maxOtpRequestsPerWindow) {
      final oldest = attempts.first;
      final retryMs = AppConstants.otpRateLimitMinutes * 60 * 1000 -
          DateTime.now().difference(oldest).inMilliseconds;
      final retryMinutes = (retryMs / 60000).ceil().clamp(1, 10);
      throw OtpRateLimitException(retryAfterMinutes: retryMinutes);
    }
  }

  Future<void> _recordLocal(String phoneE164) async {
    final attempts = await _readLocalAttempts(phoneE164);
    attempts.add(DateTime.now());
    await _writeLocalAttempts(phoneE164, attempts);
  }

  Future<List<DateTime>> _readLocalAttempts(String phoneE164) async {
    final raw = await _storage.read('${StorageKeys.otpRateLimitPrefix}$phoneE164');
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    final windowStart =
        DateTime.now().subtract(Duration(minutes: AppConstants.otpRateLimitMinutes));

    return list
        .map((e) => DateTime.tryParse(e as String))
        .whereType<DateTime>()
        .where((t) => t.isAfter(windowStart))
        .toList()
      ..sort();
  }

  Future<void> _writeLocalAttempts(
    String phoneE164,
    List<DateTime> attempts,
  ) async {
    final payload = jsonEncode(
      attempts.map((t) => t.toIso8601String()).toList(),
    );
    await _storage.write('${StorageKeys.otpRateLimitPrefix}$phoneE164', payload);
  }
}

final otpRateLimitServiceProvider = Provider<OtpRateLimitService>((ref) {
  return OtpRateLimitService(
    storage: ref.watch(localStorageProvider),
    functions: ref.watch(cloudFunctionsProvider),
  );
});
