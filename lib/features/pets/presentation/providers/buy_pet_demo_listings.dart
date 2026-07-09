import 'package:flutter/material.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';

/// Demo marketplace data — mirrors Figma Buy a Pet grid.
const buyPetDemoListings = <BuyPetListing>[
  BuyPetListing(
    id: 'labrador-pup',
    title: 'Labrador Pup',
    city: 'Riyadh',
    priceSar: 25000,
    iconAsset: 'assets/icons/pets/🐶.png',
    gradient: [Color(0xFFF4FCF6), Color(0xFF6ED99A)],
    verified: true,
  ),
  BuyPetListing(
    id: 'cockatiel-pair',
    title: 'Cockatiel Pair',
    city: 'Makkah',
    priceSar: 4500,
    iconAsset: 'assets/icons/pets/🐦.png',
    gradient: [Color(0xFFF0F8FF), Color(0xFF7FC4FF)],
  ),
  BuyPetListing(
    id: 'arabian-horse',
    title: 'Arabian Horse',
    city: 'Riyadh',
    priceSar: 180000,
    iconAsset: 'assets/icons/pets/🐴.png',
    gradient: [Color(0xFFFFF6EE), Color(0xFFFFB366)],
  ),
  BuyPetListing(
    id: 'persian-kitten',
    title: 'Persian Kitten',
    city: 'Riyadh',
    priceSar: 25000,
    emoji: '🐱',
    gradient: [Color(0xFFFAF4FF), Color(0xFFD4A8F8)],
    verified: true,
  ),
];
