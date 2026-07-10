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
  static const _designScreenWidth = 390.0;
  static const _designTagsContainerWidth = 321.0;
  static const _designApplyButtonWidth = 280.0;
  static const _chipSpacing = 8.0;
  static const _green = Color(0xFF17A855);
  static const _screenBg = Color(0xFFF8F9FB);
  static const _sliderInactive = Color(0xFFE7F8EC);
  static const _priceLabelColor = Color(0xFF95A29A);

  late Set<String> _categories;
  late RangeValues _priceRange;

  double _scaled(BuildContext context, double designValue) {
    return MediaQuery.sizeOf(context).width *
        designValue /
        _designScreenWidth;
  }

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
      backgroundColor: _screenBg,
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
                  SizedBox(
                    width: _scaled(context, _designTagsContainerWidth),
                    child: Wrap(
                      spacing: _scaled(context, _chipSpacing),
                      runSpacing: _scaled(context, _chipSpacing),
                      children: [
                        for (final categoryId in buyPetFilterCategories)
                          _CategoryChip(
                            label: context.l10n
                                .buyPetCategoryLabel(categoryId),
                            selected: _categories.contains(categoryId),
                            scale: _scaled(context, 1),
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
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: _scaled(context, _designTagsContainerWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.l10n.priceRange,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FigmaPriceRangeSlider(
                          values: _priceRange,
                          min: 5000,
                          max: 200000,
                          activeColor: _green,
                          inactiveColor: _sliderInactive,
                          onChanged: (value) =>
                              setState(() => _priceRange = value),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n
                                  .sarAmount(_priceRange.start.round()),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _priceLabelColor,
                              ),
                            ),
                            Text(
                              context.l10n
                                  .sarAmount(_priceRange.end.round()),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _priceLabelColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: _scaled(context, _designApplyButtonWidth),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _FigmaPriceRangeSlider extends StatefulWidget {
  const _FigmaPriceRangeSlider({
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
  });

  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<_FigmaPriceRangeSlider> createState() => _FigmaPriceRangeSliderState();
}

class _FigmaPriceRangeSliderState extends State<_FigmaPriceRangeSlider> {
  static const _thumbRadius = 10.0;
  static const _thumbBorder = 2.0;
  static const _trackHeight = 4.0;

  _DragTarget? _dragging;

  double get _range => widget.max - widget.min;

  double _valueToDx(double value, double width) {
    final usable = width - _thumbRadius * 2;
    if (usable <= 0 || _range <= 0) {
      return _thumbRadius;
    }
    final ratio = ((value - widget.min) / _range).clamp(0.0, 1.0);
    return _thumbRadius + ratio * usable;
  }

  double _dxToValue(double dx, double width) {
    final usable = width - _thumbRadius * 2;
    if (usable <= 0 || _range <= 0) {
      return widget.min;
    }
    final ratio = ((dx - _thumbRadius) / usable).clamp(0.0, 1.0);
    return widget.min + ratio * _range;
  }

  _DragTarget _nearestThumb(double dx, double width) {
    final startDx = _valueToDx(widget.values.start, width);
    final endDx = _valueToDx(widget.values.end, width);
    return (dx - startDx).abs() <= (dx - endDx).abs()
        ? _DragTarget.start
        : _DragTarget.end;
  }

  void _updateThumb(double dx, double width, _DragTarget target) {
    final value = _dxToValue(dx, width);
    final RangeValues next;
    if (target == _DragTarget.start) {
      final end = widget.values.end;
      next = RangeValues(value.clamp(widget.min, end), end);
    } else {
      final start = widget.values.start;
      next = RangeValues(start, value.clamp(start, widget.max));
    }
    if (next != widget.values) {
      widget.onChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackTop = _thumbRadius - _trackHeight / 2;

    return SizedBox(
      height: _thumbRadius * 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final startDx = _valueToDx(widget.values.start, width);
          final endDx = _valueToDx(widget.values.end, width);
          final activeWidth = (endDx - startDx).clamp(0.0, width);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (details) {
              _dragging = _nearestThumb(details.localPosition.dx, width);
              _updateThumb(details.localPosition.dx, width, _dragging!);
            },
            onPanUpdate: (details) {
              final target = _dragging;
              if (target != null) {
                _updateThumb(details.localPosition.dx, width, target);
              }
            },
            onPanEnd: (_) => _dragging = null,
            onPanCancel: () => _dragging = null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: _thumbRadius,
                  right: _thumbRadius,
                  top: trackTop,
                  height: _trackHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.inactiveColor,
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                    ),
                  ),
                ),
                Positioned(
                  left: startDx,
                  width: activeWidth,
                  top: trackTop,
                  height: _trackHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.activeColor,
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                    ),
                  ),
                ),
                Positioned(
                  left: startDx - _thumbRadius,
                  top: 0,
                  child: _RangeSliderThumb(
                    radius: _thumbRadius,
                    borderWidth: _thumbBorder,
                    borderColor: widget.activeColor,
                  ),
                ),
                Positioned(
                  left: endDx - _thumbRadius,
                  top: 0,
                  child: _RangeSliderThumb(
                    radius: _thumbRadius,
                    borderWidth: _thumbBorder,
                    borderColor: widget.activeColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

enum _DragTarget { start, end }

class _RangeSliderThumb extends StatelessWidget {
  const _RangeSliderThumb({
    required this.radius,
    required this.borderWidth,
    required this.borderColor,
  });

  final double radius;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
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
    required this.scale,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  static const _green = Color(0xFF17A855);
  static const _designHeight = 30.0;
  static const _designFontSize = 13.0;
  static const _designHorizontalPadding = 12.0;
  static const _unselectedBg = Color(0xFFF4FCF6);
  static const _unselectedBorder = Color(0xFFDDEFE2);
  static const _unselectedText = Color(0xFF12201A);

  @override
  Widget build(BuildContext context) {
    final height = _designHeight * scale;
    final radius = BorderRadius.circular(999 * scale);

    return IntrinsicWidth(
      child: Material(
        color: selected ? _green : _unselectedBg,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected
              ? BorderSide.none
              : const BorderSide(color: _unselectedBorder, width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: _designHorizontalPadding * scale,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _designFontSize * scale,
                fontWeight: FontWeight.w600,
                height: 1.2,
                letterSpacing: 0,
                color: selected ? Colors.white : _unselectedText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
