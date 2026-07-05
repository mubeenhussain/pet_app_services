import 'package:pet_app/shared/models/pet_model.dart';

abstract class PetsRepository {
  Stream<List<PetModel>> watchPets(String ownerId);
  Future<PetModel?> getPet(String id);
  Future<PetModel> createPet(PetModel pet);
  Future<void> updatePet(PetModel pet);
  Future<void> deletePet(String id);
}
