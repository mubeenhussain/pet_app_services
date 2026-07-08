import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:pet_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pet_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_app/features/pets/data/datasources/pets_firestore_datasource.dart';
import 'package:pet_app/features/pets/data/repositories/pets_repository_impl.dart';
import 'package:pet_app/features/pets/domain/repositories/pets_repository.dart';
import 'package:pet_app/features/rides/data/datasources/rides_firestore_datasource.dart';
import 'package:pet_app/features/rides/data/repositories/rides_repository_impl.dart';
import 'package:pet_app/features/rides/domain/repositories/rides_repository.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/shared/models/auth_session.dart';
import 'package:pet_app/shared/models/user_model.dart';
import 'package:pet_app/shared/providers/guest_mode_provider.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final localStorageProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);

final authRemoteDataSourceProvider = Provider<AuthFirebaseDataSource>((ref) {
  return AuthFirebaseDataSource(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    storage: ref.watch(localStorageProvider),
  );
});

final petsRemoteDataSourceProvider = Provider<PetsFirestoreDataSource>((ref) {
  return PetsFirestoreDataSource(ref.watch(firestoreProvider));
});

final petsRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepositoryImpl(ref.watch(petsRemoteDataSourceProvider));
});

final ridesRemoteDataSourceProvider = Provider<RidesFirestoreDataSource>((ref) {
  return RidesFirestoreDataSource(ref.watch(firestoreProvider));
});

final ridesRepositoryProvider = Provider<RidesRepository>((ref) {
  return RidesRepositoryImpl(ref.watch(ridesRemoteDataSourceProvider));
});

final authStateProvider = StreamProvider<AuthSession>((ref) async* {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  ref.watch(guestModeProvider);

  final persistedGuest = await storage.isGuestMode();
  if (persistedGuest) {
    ref.read(guestModeProvider.notifier).state = true;
  }

  await for (final firebaseUser in repository.authStateChanges()) {
    if (firebaseUser == null) {
      final local = await storage.readLocalAuthSession();
      if (local != null) {
        await storage.clearGuestMode();
        ref.read(guestModeProvider.notifier).state = false;
        yield AuthSession(
          user: UserModel(
            uid: local.uid.isEmpty ? 'local_${local.phone}' : local.uid,
            username: local.username,
            phone: local.phone,
            email: local.email,
            city: local.city,
            role: UserRole.petOwner,
            createdAt: local.createdAtYear == null
                ? null
                : DateTime(local.createdAtYear!),
          ),
        );
        continue;
      }

      final isGuest =
          ref.read(guestModeProvider) || await storage.isGuestMode();
      yield isGuest ? AuthSession.guest : AuthSession.unauthenticated;
      continue;
    }

    await storage.clearGuestMode();
    await storage.clearLocalAuthSession();
    ref.read(guestModeProvider.notifier).state = false;
    final profile = await repository.getUserProfile(firebaseUser.uid);
    yield AuthSession(user: profile);
  }
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.user;
});

/// Local fallback of last successful login/register profile for User Settings.
final cachedUserProfileProvider = FutureProvider<CachedUserProfile?>((ref) {
  return ref.watch(localStorageProvider).readCachedUserProfile();
});
