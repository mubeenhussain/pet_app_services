import 'package:flutter/material.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';
import 'package:pet_app/features/pets/presentation/providers/buy_pet_demo_listings.dart';

class BuyPetFiltersArgs {
  const BuyPetFiltersArgs({
    required this.categories,
    required this.priceRange,
    required this.searchQuery,
  });

  final Set<String> categories;
  final RangeValues priceRange;
  final String searchQuery;
}

class BuyPetFilterResult {
  const BuyPetFilterResult({
    required this.categories,
    required this.priceRange,
  });

  final Set<String> categories;
  final RangeValues priceRange;
}

const buyPetFilterCategories = [
  'dogs',
  'cats',
  'birds',
  'horses',
  'camels',
  'adoption',
];

const defaultBuyPetPriceRange = RangeValues(5000, 200000);

List<BuyPetListing> filterBuyPetListings({
  required String query,
  required Set<String> categories,
  required RangeValues priceRange,
}) {
  final q = query.trim().toLowerCase();
  return buyPetDemoListings.where((item) {
    if (q.isNotEmpty &&
        !item.title.toLowerCase().contains(q) &&
        !item.city.toLowerCase().contains(q)) {
      return false;
    }
    if (categories.isNotEmpty && !categories.contains(item.category)) {
      return false;
    }
    if (item.priceSar < priceRange.start.round() ||
        item.priceSar > priceRange.end.round()) {
      return false;
    }
    return true;
  }).toList(growable: false);
}
