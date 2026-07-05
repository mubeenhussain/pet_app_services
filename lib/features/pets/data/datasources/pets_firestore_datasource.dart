import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/shared/models/pet_model.dart';

class PetsFirestoreDataSource {
  PetsFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _pets =>
      _firestore.collection('pets');

  Stream<List<PetModel>> watchPets(String ownerId) {
    return _pets.where('ownerId', isEqualTo: ownerId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => PetModel.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Future<PetModel?> getPet(String id) async {
    final doc = await _pets.doc(id).get();
    if (!doc.exists) return null;
    return PetModel.fromMap(doc.data()!, id: doc.id);
  }

  Future<PetModel> createPet(PetModel pet) async {
    final doc = await _pets.add(pet.toMap());
    return PetModel(
      id: doc.id,
      ownerId: pet.ownerId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      age: pet.age,
      gender: pet.gender,
      photoUrl: pet.photoUrl,
    );
  }

  Future<void> updatePet(PetModel pet) async {
    await _pets.doc(pet.id).update(pet.toMap());
  }

  Future<void> deletePet(String id) async {
    await _pets.doc(id).delete();
  }
}
