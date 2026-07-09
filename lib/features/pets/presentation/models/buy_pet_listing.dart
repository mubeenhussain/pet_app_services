import 'package:flutter/material.dart';

/// Marketplace listing shown on [BuyPetScreen] (Figma — Buy a Pet).
class BuyPetListing {
  const BuyPetListing({
    required this.id,
    required this.title,
    required this.city,
    required this.priceSar,
    required this.gradient,
    this.iconAsset,
    this.emoji,
    this.verified = false,
  });

  final String id;
  final String title;
  final String city;
  final int priceSar;
  final List<Color> gradient;
  final String? iconAsset;
  final String? emoji;
  final bool verified;
}
