import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  static const _green = Color(0xFF17A855);
  static const _priceColor = Color(0xFF0F8A42);

  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final priceFormat = NumberFormat('#,###');

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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.chevron_left,
                          onTap: () => context.pop(),
                        ),
                        const Spacer(),
                        _CircleIconButton(
                          icon: _favorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: _favorited ? const Color(0xFFE53935) : null,
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
                            if (listing.verified) const _VerifiedBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          listing.breedAgeLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'SAR ${priceFormat.format(listing.priceSar)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _priceColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LinkRow(
                          label: 'Provider Details',
                          onTap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF0F2F5),
                        ),
                        _LinkRow(
                          label: 'Flag Interest / Report',
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
                              child: const Text(
                                'Ask About Pet',
                                style: TextStyle(
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
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
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
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(
            icon,
            size: 22,
            color: iconColor ?? AppColors.textSecondary,
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, size: 14, color: _green),
            SizedBox(width: 4),
            Text(
              'Verified',
              style: TextStyle(
                fontSize: 11,
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
