import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/l10n/app_localizations.dart';

/// Primary bottom tabs from Figma home navigation.
enum AppBottomTab { home, services, rescue, profile }

/// Fixed 4-tab bottom navigation matching Figma:
/// selected: dark forest green · unselected: medium grey · labels always shown.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final AppBottomTab current;
  final ValueChanged<AppBottomTab> onChanged;

  static const selectedColor = Color(0xFF1E8449);
  static const unselectedColor = Color(0xFF909497);
  static const topBorder = Color(0xFFE8EAEF);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: topBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (final tab in AppBottomTab.values)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    selected: tab == current,
                    label: _labelFor(tab, l10n),
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _labelFor(AppBottomTab tab, AppLocalizations l10n) =>
      switch (tab) {
        AppBottomTab.home => l10n.navHome,
        AppBottomTab.services => l10n.navServices,
        AppBottomTab.rescue => l10n.navRescue,
        AppBottomTab.profile => l10n.navProfile,
      };
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AppBottomTab tab;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppBottomNav.selectedColor
        : AppBottomNav.unselectedColor;

    return InkWell(
      onTap: onTap,
      splashColor: AppBottomNav.selectedColor.withValues(alpha: 0.08),
      highlightColor: AppBottomNav.selectedColor.withValues(alpha: 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color color) {
    final asset = _assetFor(tab);
    if (asset == null) {
      return Icon(
        _materialIconFor(tab, selected),
        size: _iconSize,
        color: color,
      );
    }

    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image.asset(
        asset,
        width: _iconSize,
        height: _iconSize,
        fit: BoxFit.contain,
      ),
    );
  }

  static String? _assetFor(AppBottomTab tab) => switch (tab) {
        AppBottomTab.home => null,
        AppBottomTab.services => 'assets/icons/system/bottombar_menu.png',
        AppBottomTab.rescue => 'assets/icons/system/bottombar_rescu.png',
        AppBottomTab.profile => 'assets/icons/system/bottombar_profile.png',
      };

  static IconData _materialIconFor(AppBottomTab tab, bool selected) =>
      switch (tab) {
        AppBottomTab.home =>
          selected ? Icons.home_rounded : Icons.home_outlined,
        AppBottomTab.services => Icons.menu_rounded,
        AppBottomTab.rescue => Icons.health_and_safety_outlined,
        AppBottomTab.profile =>
          selected ? Icons.person : Icons.person_outline,
      };
}
