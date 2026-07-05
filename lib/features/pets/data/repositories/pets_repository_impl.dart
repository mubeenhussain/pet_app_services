import 'package:pet_app/features/pets/data/datasources/pets_firestore_datasource.dart';
import 'package:pet_app/features/pets/domain/repositories/pets_repository.dart';
import 'package:pet_app/shared/models/pet_model.dart';

class PetsRepositoryImpl implements PetsRepository {
  PetsRepositoryImpl(this._dataSource);

  final PetsFirestoreDataSource _dataSource;

  @override
  Stream<List<PetModel>> watchPets(String ownerId) =>
      _dataSource.watchPets(ownerId);

  @override
  Future<PetModel?> getPet(String id) => _dataSource.getPet(id);

  @override
  Future<PetModel> createPet(PetModel pet) => _dataSource.createPet(pet);

  @override
  Future<void> updatePet(PetModel pet) => _dataSource.updatePet(pet);

  @override
  Future<void> deletePet(String id) => _dataSource.deletePet(id);
}
