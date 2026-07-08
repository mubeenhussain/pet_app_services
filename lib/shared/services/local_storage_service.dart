import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_app/core/constants/storage_keys.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';

class PendingRegisterDraft {
  const PendingRegisterDraft({
    required this.username,
    required this.phone,
    required this.password,
    required this.city,
  });

  final String username;
  final String phone;
  final String password;
  final String city;

  Map<String, dynamic> toJson() => {
        'username': username,
        'phone': phone,
        'city': city,
      };

  factory PendingRegisterDraft.fromJson(
    Map<String, dynamic> json, {
    required String password,
  }) {
    return PendingRegisterDraft(
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: password,
      city: json['city'] as String? ?? '',
    );
  }
}

class CachedUserProfile {
  const CachedUserProfile({
    required this.uid,
    required this.username,
    required this.phone,
    this.email,
    this.city,
    this.createdAtYear,
  });

  final String uid;
  final String username;
  final String phone;
  final String? email;
  final String? city;
  final int? createdAtYear;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'phone': phone,
        'email': email,
        'city': city,
        'createdAtYear': createdAtYear,
      };

  factory CachedUserProfile.fromJson(Map<String, dynamic> json) {
    return CachedUserProfile(
      uid: json['uid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      city: json['city'] as String?,
      createdAtYear: json['createdAtYear'] as int?,
    );
  }
}

class LocalStorageService {
  LocalStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> read(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> write(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  Future<bool> isGuestMode() async {
    final prefs = await _prefs;
    return prefs.getBool(StorageKeys.guestMode) ?? false;
  }

  Future<void> setGuestMode(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(StorageKeys.guestMode, value);
  }

  Future<void> clearGuestMode() async {
    await setGuestMode(false);
  }

  Future<void> savePendingOtpSession({
    required PhoneAuthSession session,
    required String phone,
    required String flow,
  }) async {
    final payload = jsonEncode({
      'verificationId': session.verificationId,
      'resendToken': session.resendToken,
      'phone': phone,
      'flow': flow,
      'savedAt': DateTime.now().toIso8601String(),
    });
    await write(StorageKeys.pendingOtpSession, payload);
  }

  Future<({PhoneAuthSession session, String phone, String flow})?>
      readPendingOtpSession() async {
    final raw = await read(StorageKeys.pendingOtpSession);
    if (raw == null || raw.isEmpty) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    final verificationId = map['verificationId'] as String?;
    if (verificationId == null || verificationId.isEmpty) return null;

    return (
      session: PhoneAuthSession(
        verificationId: verificationId,
        resendToken: map['resendToken'] as int?,
      ),
      phone: map['phone'] as String? ?? '',
      flow: map['flow'] as String? ?? 'register',
    );
  }

  Future<void> clearPendingOtpSession() async {
    await remove(StorageKeys.pendingOtpSession);
  }

  Future<void> savePendingRegister(PendingRegisterDraft draft) async {
    await write(StorageKeys.pendingRegister, jsonEncode(draft.toJson()));
    await _secureStorage.write(
      key: StorageKeys.pendingRegisterPassword,
      value: draft.password,
    );
  }

  Future<PendingRegisterDraft?> readPendingRegister() async {
    final raw = await read(StorageKeys.pendingRegister);
    if (raw == null || raw.isEmpty) return null;

    final password =
        await _secureStorage.read(key: StorageKeys.pendingRegisterPassword);
    if (password == null || password.isEmpty) return null;

    return PendingRegisterDraft.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
      password: password,
    );
  }

  Future<void> clearPendingRegister() async {
    await remove(StorageKeys.pendingRegister);
    await _secureStorage.delete(key: StorageKeys.pendingRegisterPassword);
  }

  Future<void> saveCachedUserProfile(CachedUserProfile profile) async {
    await write(StorageKeys.cachedUserProfile, jsonEncode(profile.toJson()));
  }

  Future<CachedUserProfile?> readCachedUserProfile() async {
    final raw = await read(StorageKeys.cachedUserProfile);
    if (raw == null || raw.isEmpty) return null;
    return CachedUserProfile.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<void> clearCachedUserProfile() async {
    await remove(StorageKeys.cachedUserProfile);
  }

  Future<void> saveLocalAuthSession(
    CachedUserProfile profile, {
    required String password,
  }) async {
    await write(StorageKeys.localAuthSession, jsonEncode(profile.toJson()));
    await _secureStorage.write(
      key: StorageKeys.localAuthPassword,
      value: password,
    );
    await saveCachedUserProfile(profile);
  }

  Future<CachedUserProfile?> readLocalAuthSession() async {
    final raw = await read(StorageKeys.localAuthSession);
    if (raw == null || raw.isEmpty) return null;
    return CachedUserProfile.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<String?> readLocalAuthPassword() {
    return _secureStorage.read(key: StorageKeys.localAuthPassword);
  }

  Future<void> clearLocalAuthSession() async {
    await remove(StorageKeys.localAuthSession);
    await _secureStorage.delete(key: StorageKeys.localAuthPassword);
  }
}
