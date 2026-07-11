import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/l10n/l10n_helpers.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';
import 'package:pet_app/features/pets/presentation/widgets/ask_about_pet_sheet.dart';

/// Figma — Animal Details
class BuyPetDetailScreen extends StatefulWidget {
  const BuyPetDetailScreen({super.key, required this.listing});

  final BuyPetListing listing;

  @override
  State<BuyPetDetailScreen> createState() => _BuyPetDetailScreenState();
}

class _BuyPetDetailScreenState extends State<BuyPetDetailScreen> {
  static const _designScreenWidth = 390.0;
  static const _designHeaderTop = 4.0;
  static const _designHeaderHorizontal = 16.0;
  static const _designHeaderHeight = 36.0;
  static const _green = Color(0xFF17A855);
  static const _priceColor = Color(0xFF0F8A42);

  bool _favorited = false;

  double _scaled(BuildContext context, double designValue) {
    return MediaQuery.sizeOf(context).width *
        designValue /
        _designScreenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final topInset = MediaQuery.paddingOf(context).top;
    final s = (double value) => _scaled(context, value);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 46,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: listing.gradient,
                    ),
                  ),
                  child: Center(child: _HeroVisual(listing: listing)),
                ),
                Positioned(
                  top: topInset + s(_designHeaderTop),
                  left: s(_designHeaderHorizontal),
                  right: s(_designHeaderHorizontal),
                  child: SizedBox(
                    height: s(_designHeaderHeight),
                    child: Row(
                      children: [
                        _CircleIconButton(
                          size: s(_designHeaderHeight),
                          icon: Icons.chevron_left,
                          onTap: () => context.pop(),
                        ),
                        const Spacer(),
                        _CircleIconButton(
                          size: s(_designHeaderHeight),
                          icon: _favorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: _favorited
                              ? const Color(0xFFE53935)
                              : _green,
                          onTap: () =>
                              setState(() => _favorited = !_favorited),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _PageDots(activeIndex: 0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 54,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                listing.petName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (listing.verified) const _DetailVerifiedBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.breedAgeLine(listing.breed, listing.ageYears),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.sarAmount(listing.priceSar),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _priceColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LinkRow(
                          label: context.l10n.providerDetails,
                          onTap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF0F2F5),
                        ),
                        _LinkRow(
                          label: context.l10n.flagInterestReport,
                          labelColor: const Color(0xFFC62828),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  showAskAboutPetSheet(context, listing),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _green,
                                side: const BorderSide(color: _green),
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                context.l10n.askAboutPet,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: _green,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                context.l10n.buyNow,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.listing});

  final BuyPetListing listing;

  @override
  Widget build(BuildContext context) {
    if (listing.iconAsset != null) {
      return Image.asset(
        listing.iconAsset!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }
    return Text(
      listing.emoji ?? '🐾',
      style: const TextStyle(fontSize: 96, height: 1),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size = 36,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? iconColor;

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(
            icon,
            size: size * 0.5,
            color: iconColor ?? _green,
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: active ? 1 : 0.55),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _DetailVerifiedBadge extends StatelessWidget {
  const _DetailVerifiedBadge();

  static const _green = Color(0xFF0F8A42);
  static const _badgeBg = Color(0xFFE7F8EC);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const SizedBox(
        height: 21,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_rounded,
                size: 12,
                color: _green,
                weight: 700,
              ),
              SizedBox(width: 4),
              _DetailVerifiedLabel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailVerifiedLabel extends StatelessWidget {
  const _DetailVerifiedLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.verified,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0,
        color: _DetailVerifiedBadge._green,
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: labelColor ?? AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
