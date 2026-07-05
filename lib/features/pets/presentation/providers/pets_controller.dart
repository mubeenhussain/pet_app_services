import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/features/pets/domain/repositories/pets_repository.dart';
import 'package:pet_app/shared/models/pet_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

final petsListProvider = StreamProvider.autoDispose<List<PetModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(petsRepositoryProvider).watchPets(user.uid);
});

final petsControllerProvider =
    StateNotifierProvider<PetsController, AsyncValue<void>>((ref) {
  return PetsController(ref.watch(petsRepositoryProvider));
});

class PetsController extends StateNotifier<AsyncValue<void>> {
  PetsController(this._repository) : super(const AsyncData(null));

  final PetsRepository _repository;

  Future<PetModel?> create(PetModel pet) async {
    state = const AsyncLoading();
    PetModel? created;
    state = await AsyncValue.guard(() async {
      created = await _repository.createPet(pet);
    });
    return created;
  }

  Future<void> update(PetModel pet) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.updatePet(pet));
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.deletePet(id));
  }
}
