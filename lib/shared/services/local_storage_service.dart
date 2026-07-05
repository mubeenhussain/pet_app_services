import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_app/core/constants/storage_keys.dart';

class LocalStorageService {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> read(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> write(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
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
}
