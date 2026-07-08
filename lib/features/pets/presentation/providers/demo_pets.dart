import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/models/pet_model.dart';

/// Demo pets for UI preview when backend has no pets yet.
const kDemoPets = <PetModel>[
  PetModel(
    id: 'dummy_buddy_1',
    ownerId: 'demo',
    name: 'Buddy',
    species: 'Dog',
    breed: 'Golden Retriever',
    age: 3,
    gender: 'male',
  ),
  PetModel(
    id: 'dummy_milo_1',
    ownerId: 'demo',
    name: 'Milo',
    species: 'Cat',
    breed: 'Persian',
    age: 1,
    gender: 'male',
  ),
  PetModel(
    id: 'dummy_buddy_2',
    ownerId: 'demo',
    name: 'Buddy',
    species: 'Dog',
    breed: 'Labrador',
    age: 3,
    gender: 'male',
  ),
  PetModel(
    id: 'dummy_milo_2',
    ownerId: 'demo',
    name: 'Milo',
    species: 'Cat',
    age: 1,
    gender: 'female',
  ),
  PetModel(
    id: 'dummy_rio_1',
    ownerId: 'demo',
    name: 'Rio',
    species: 'Bird',
    age: 2,
    gender: 'male',
  ),
];

bool isDemoPetId(String id) => id.startsWith('dummy_');

/// In-memory demo pet list (editable until backend pets exist).
final demoPetsProvider =
    StateProvider<List<PetModel>>((ref) => List<PetModel>.from(kDemoPets));
