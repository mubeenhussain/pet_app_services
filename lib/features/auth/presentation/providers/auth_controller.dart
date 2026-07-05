import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/errors/error_handler.dart';
import 'package:pet_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/guest_mode_provider.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
    ref.watch(localStorageProvider),
  );
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repository, this._ref, this._storage)
      : super(const AsyncData(null));

  final AuthRepository _repository;
  final Ref _ref;
  final LocalStorageService _storage;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _storage.clearGuestMode();
      _ref.read(guestModeProvider.notifier).state = false;
      await _repository.signInWithEmail(email, password);
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String city,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.registerWithEmail(
        email: email,
        password: password,
        username: username,
        phone: phone,
        city: city,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signInWithGoogle);
  }

  Future<void> skipAsGuest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.enableGuestMode();
      _ref.read(guestModeProvider.notifier).state = true;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signOut);
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.sendPasswordResetEmail(email));
  }

  String? mapError(Object error) => ErrorHandler.mapException(error).message;
}
