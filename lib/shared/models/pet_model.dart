import 'package:equatable/equatable.dart';

class PetModel extends Equatable {
  const PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.gender,
    this.photoUrl,
  });

  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? gender;
  final String? photoUrl;

  factory PetModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return PetModel(
      id: id,
      ownerId: map['ownerId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      species: map['species'] as String? ?? '',
      breed: map['breed'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender,
      'photoUrl': photoUrl,
    };
  }

  PetModel copyWith({
    String? name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    String? photoUrl,
  }) {
    return PetModel(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, ownerId, name, species];
}
