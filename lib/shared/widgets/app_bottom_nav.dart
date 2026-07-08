import 'package:flutter/material.dart';

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
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppBottomTab tab;
  final bool selected;
  final VoidCallback onTap;

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
          Icon(_iconFor(tab, selected), size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            _labelFor(tab),
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

  static String _labelFor(AppBottomTab tab) => switch (tab) {
        AppBottomTab.home => 'Home',
        AppBottomTab.services => 'Services',
        AppBottomTab.rescue => 'Rescue',
        AppBottomTab.profile => 'Profile',
      };

  static IconData _iconFor(AppBottomTab tab, bool selected) => switch (tab) {
        AppBottomTab.home =>
          selected ? Icons.home_rounded : Icons.home_outlined,
        AppBottomTab.services => Icons.menu_rounded,
        AppBottomTab.rescue => Icons.health_and_safety_outlined,
        AppBottomTab.profile =>
          selected ? Icons.person : Icons.person_outline,
      };
}
