import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/l10n/l10n_helpers.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';
import 'package:pet_app/features/pets/presentation/utils/buy_pet_filters.dart';
import 'package:pet_app/shared/widgets/app_empty_state.dart';

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

  static const _designScreenWidth = 390.0;
  static const _designSearchWidth = 300.0;
  static const _horizontalPadding = 16.0;
  static const _designHeaderTop = 63.0;
  static const _headerColor = Color(0xFF12201A);
  static const _gridSpacing = 12.0;
  static const _designCardWidth = 156.0;
  static const _designCardHeight = 193.0;

  double _scaled(BuildContext context, double designValue) {
    return MediaQuery.sizeOf(context).width * designValue / _designScreenWidth;
  }

  double _headerTopPadding(BuildContext context) {
    final topBelowSafe =
        _scaled(context, _designHeaderTop) - MediaQuery.paddingOf(context).top;
    return topBelowSafe.clamp(8.0, 32.0);
  }

  double _searchWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width * _designSearchWidth / _designScreenWidth;
  }

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

    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: _headerTopPadding(context)),
                child: Text(
                  context.l10n.buyAPet,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 25.5 / 17,
                    letterSpacing: 0,
                    color: _headerColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: _searchWidth(context),
                    child: _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  Material(
                    color: _green,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _openFilters,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Image.asset(
                            'assets/icons/system/filter.png',
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: listings.isEmpty
                    ? AppEmptyState(
                        title: context.l10n.noListingsFound,
                        subtitle: context.l10n.tryAdjustingFilters,
                        icon: Icons.search_rounded,
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: _gridSpacing,
                                mainAxisSpacing: _gridSpacing,
                                mainAxisExtent: _scaled(context, _designCardHeight),
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _BuyPetCard(
                                  listing: listings[index],
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
  static const _placeholder = Color(0xFF9CA3AF);
  static const _height = 44.0;
  static const _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
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
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 19.5 / 13,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: context.l10n.searchBreedCity,
              hintStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 19.5 / 13,
                color: _placeholder,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: Colors.black,
              ),
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuyPetCard extends StatelessWidget {
  const _BuyPetCard({required this.listing});

  final BuyPetListing listing;

  static const _designScreenWidth = 390.0;
  static const _designImageInset = 20.0;
  static const _designTextStartPadding = 35.0;
  static const _designPetIconHeight = 39.0;
  static const _designVerifiedIconSize = 12.0;
  static const _designVerifiedFontSize = 10.5;
  static const _designVerifiedBadgeRadius = 20.0;
  static const _cardBorder = Color(0xFFDDEFE2);
  static const _titleColor = Color(0xFF12201A);
  static const _cityColor = Color(0xFF95A29A);
  static const _priceColor = Color(0xFF0F8A42);
  static const _gradientStops = [0.0, 0.52];

  static double _scaled(BuildContext context, double designValue) {
    return MediaQuery.sizeOf(context).width *
        designValue /
        _designScreenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final s = (double value) => _scaled(context, value);

    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _cardBorder, width: 0.8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(RouteNames.buyPetDetailPath(listing.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: s(11)),
              child: SizedBox(
                height: s(93),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: s(_designImageInset),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(s(12)),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: listing.gradient,
                                stops: _gradientStops,
                              ),
                            ),
                            child: Center(
                              child: _PetVisual(
                                listing: listing,
                                height: s(_designPetIconHeight),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (listing.verified)
                        Positioned(
                          top: s(6),
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _VerifiedBadge(scale: s(1)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: s(_designTextStartPadding),
                top: s(6),
                bottom: s(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0,
                      color: _titleColor,
                    ),
                  ),
                  SizedBox(height: s(2)),
                  Text(
                    listing.city,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0,
                      color: _cityColor,
                    ),
                  ),
                  SizedBox(height: s(2)),
                  Text(
                    context.l10n.sarAmount(listing.priceSar),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0,
                      color: _priceColor,
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

class _PetVisual extends StatelessWidget {
  const _PetVisual({
    required this.listing,
    this.height = 39,
  });

  final BuyPetListing listing;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (listing.iconAsset != null) {
      return Image.asset(
        listing.iconAsset!,
        height: height,
        fit: BoxFit.contain,
      );
    }
    return Text(
      listing.emoji ?? '🐾',
      style: TextStyle(fontSize: height * 0.85, height: 1),
    );
  }
}

class _VerifiedCheckmark extends StatelessWidget {
  const _VerifiedCheckmark({required this.size});

  final double size;

  static const _green = Color(0xFF0F8A42);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: _green,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.check_rounded,
        size: size * 0.72,
        color: Colors.white,
        weight: 700,
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({this.scale = 1});

  final double scale;

  static const _green = Color(0xFF0F8A42);

  @override
  Widget build(BuildContext context) {
    final iconSize = _BuyPetCard._designVerifiedIconSize * scale;
    final fontSize = _BuyPetCard._designVerifiedFontSize * scale;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          _BuyPetCard._designVerifiedBadgeRadius * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6 * scale,
            offset: Offset(0, 1 * scale),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6 * scale,
          vertical: 3 * scale,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _VerifiedCheckmark(size: iconSize),
            SizedBox(width: 3 * scale),
            Text(
              context.l10n.verified,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: 0,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.loadingMore,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
