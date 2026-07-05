import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/constants/storage_keys.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(const Locale('en')) {
    _load();
  }

  final LocalStorageService _storage;

  Future<void> _load() async {
    final code = await _storage.read(StorageKeys.locale);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.write(StorageKeys.locale, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    await setLocale(state.languageCode == 'en' ? const Locale('ar') : const Locale('en'));
  }
}
