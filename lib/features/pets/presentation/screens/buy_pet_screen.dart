import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';
import 'package:pet_app/features/pets/presentation/utils/buy_pet_filters.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

/// Figma — Buy a Pet marketplace (home → Buy & Sell → See all).
class BuyPetScreen extends StatefulWidget {
  const BuyPetScreen({super.key});

  @override
  State<BuyPetScreen> createState() => _BuyPetScreenState();
}

class _BuyPetScreenState extends State<BuyPetScreen> {
  static const _green = Color(0xFF17A855);
  static const _screenBg = Color(0xFFF8F9FB);

  final _searchController = TextEditingController();
  String _query = '';
  Set<String> _categories = {};
  RangeValues _priceRange = defaultBuyPetPriceRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BuyPetListing> get _filtered => filterBuyPetListings(
        query: _query,
        categories: _categories,
        priceRange: _priceRange,
      );

  Future<void> _openFilters() async {
    final result = await context.push<BuyPetFilterResult>(
      RouteNames.buyPetFilters,
      extra: BuyPetFiltersArgs(
        categories: _categories,
        priceRange: _priceRange,
        searchQuery: _query,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _categories = Set<String>.from(result.categories);
      _priceRange = result.priceRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filtered;
    final priceFormat = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const AuthCircleBackButton(),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Buy a Pet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: _green,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _openFilters,
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _BuyPetCard(
                          listing: listings[index],
                          priceFormat: priceFormat,
                        ),
                        childCount: listings.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: _LoadingMoreFooter(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const _border = Color(0xFFDDEFE2);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _border, width: 0.8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            hintText: 'Search breed, city...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 22,
              color: AppColors.textSecondary,
            ),
            filled: false,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _BuyPetCard extends StatelessWidget {
  const _BuyPetCard({
    required this.listing,
    required this.priceFormat,
  });

  final BuyPetListing listing;
  final NumberFormat priceFormat;

  static const _cardBorder = Color(0xFFDDEFE2);
  static const _priceColor = Color(0xFF0F8A42);
  static const _gradientStops = [0.0, 0.52];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _cardBorder, width: 0.8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: listing.gradient,
                            stops: _gradientStops,
                          ),
                        ),
                        child: Center(child: _PetVisual(listing: listing)),
                      ),
                    ),
                    if (listing.verified)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: _VerifiedBadge(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                listing.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                listing.city,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SAR ${priceFormat.format(listing.priceSar)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _priceColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetVisual extends StatelessWidget {
  const _PetVisual({required this.listing});

  final BuyPetListing listing;

  @override
  Widget build(BuildContext context) {
    if (listing.iconAsset != null) {
      return Image.asset(
        listing.iconAsset!,
        width: 48,
        height: 48,
        fit: BoxFit.contain,
      );
    }
    return Text(
      listing.emoji ?? '🐾',
      style: const TextStyle(fontSize: 40, height: 1),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  static const _green = Color(0xFF0F8A42);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, size: 12, color: _green),
            SizedBox(width: 3),
            Text(
              'Verified',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingMoreFooter extends StatelessWidget {
  const _LoadingMoreFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Loading more...',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
