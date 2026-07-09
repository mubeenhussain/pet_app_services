import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/l10n/l10n_helpers.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/utils/buy_pet_filters.dart';

/// Figma — Buy a Pet filters (full screen).
class BuyPetFiltersScreen extends StatefulWidget {
  const BuyPetFiltersScreen({super.key, required this.args});

  final BuyPetFiltersArgs args;

  @override
  State<BuyPetFiltersScreen> createState() => _BuyPetFiltersScreenState();
}

class _BuyPetFiltersScreenState extends State<BuyPetFiltersScreen> {
  static const _green = Color(0xFF17A855);

  late Set<String> _categories;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _categories = Set<String>.from(widget.args.categories);
    _priceRange = widget.args.priceRange;
  }

  int get _resultCount => filterBuyPetListings(
        query: widget.args.searchQuery,
        categories: _categories,
        priceRange: _priceRange,
      ).length;

  void _reset() {
    setState(() {
      _categories = {};
      _priceRange = defaultBuyPetPriceRange;
    });
  }

  void _apply() {
    context.pop(
      BuyPetFilterResult(
        categories: Set<String>.from(_categories),
        priceRange: _priceRange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  _FilterCloseButton(onTap: () => context.pop()),
                  Expanded(
                    child: Text(
                      context.l10n.filters,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _reset,
                    child: Text(
                      context.l10n.reset,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F2F5)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                children: [
                  Text(
                    context.l10n.category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final categoryId in buyPetFilterCategories)
                        _CategoryChip(
                          label: context.l10n.buyPetCategoryLabel(categoryId),
                          selected: _categories.contains(categoryId),
                          onTap: () => setState(() {
                            if (_categories.contains(categoryId)) {
                              _categories.remove(categoryId);
                            } else {
                              _categories.add(categoryId);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    context.l10n.priceRange,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _green,
                      inactiveTrackColor: const Color(0xFFE8EAEF),
                      thumbColor: Colors.white,
                      overlayColor: _green.withValues(alpha: 0.12),
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 5000,
                      max: 200000,
                      divisions: 39,
                      onChanged: (value) =>
                          setState(() => _priceRange = value),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.sarAmount(_priceRange.start.round()),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        context.l10n.sarAmount(_priceRange.end.round()),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _apply,
                  child: Text(
                    context.l10n.applyWithCount(_resultCount),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterCloseButton extends StatelessWidget {
  const _FilterCloseButton({required this.onTap});

  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: Colors.white,
        shape: CircleBorder(
          side: BorderSide(color: _green.withValues(alpha: 0.55)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Icon(Icons.close, size: 20, color: _green),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _green : const Color(0xFFF0F2F5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
