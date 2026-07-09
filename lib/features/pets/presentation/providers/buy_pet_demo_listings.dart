import 'package:flutter/material.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';

/// Demo marketplace data — mirrors Figma Buy a Pet grid.
final buyPetDemoListings = <BuyPetListing>[
  BuyPetListing(
    id: 'labrador-pup',
    title: 'Labrador Pup',
    petName: 'Buddy',
    breed: 'Golden Retriever',
    ageYears: 3,
    city: 'Riyadh',
    priceSar: 25000,
    category: 'dogs',
    iconAsset: 'assets/icons/pets/🐶.png',
    gradient: [Color(0xFFF4FCF6), Color(0xFF6ED99A)],
    verified: true,
  ),
  BuyPetListing(
    id: 'cockatiel-pair',
    title: 'Cockatiel Pair',
    petName: 'Sunny & Sky',
    breed: 'Cockatiel',
    ageYears: 2,
    city: 'Makkah',
    priceSar: 4500,
    category: 'birds',
    iconAsset: 'assets/icons/pets/🐦.png',
    gradient: [Color(0xFFF0F8FF), Color(0xFF7FC4FF)],
  ),
  BuyPetListing(
    id: 'arabian-horse',
    title: 'Arabian Horse',
    petName: 'Majesty',
    breed: 'Arabian Horse',
    ageYears: 5,
    city: 'Riyadh',
    priceSar: 180000,
    category: 'horses',
    iconAsset: 'assets/icons/pets/🐴.png',
    gradient: [Color(0xFFFFF6EE), Color(0xFFFFB366)],
  ),
  BuyPetListing(
    id: 'persian-kitten',
    title: 'Persian Kitten',
    petName: 'Luna',
    breed: 'Persian Cat',
    ageYears: 1,
    city: 'Riyadh',
    priceSar: 25000,
    category: 'cats',
    emoji: '🐱',
    gradient: [Color(0xFFFAF4FF), Color(0xFFD4A8F8)],
    verified: true,
  ),
];

BuyPetListing? buyPetListingById(String id) {
  for (final listing in buyPetDemoListings) {
    if (listing.id == id) return listing;
  }
  return null;
}
