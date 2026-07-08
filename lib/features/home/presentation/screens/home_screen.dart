import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_bottom_nav.dart';
import 'package:pet_app/shared/widgets/app_drawer.dart';

/// BRD 6.13 — Home shell with Figma home + bottom navigation.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppBottomTab _tab = AppBottomTab.home;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final cached = ref.watch(cachedUserProfileProvider).valueOrNull;
    final name = (user?.username.isNotEmpty == true
            ? user!.username
            : null) ??
        (cached?.username.isNotEmpty == true ? cached!.username : null) ??
        'Guest';
    final firstName = name.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FB),
      drawer: AppDrawer(username: name),
      body: IndexedStack(
        index: _tab.index,
        children: [
          _HomeTab(
            firstName: firstName,
            fullName: name,
            onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
            onOpenProfile: () => setState(() => _tab = AppBottomTab.profile),
          ),
          const _PlaceholderTab(
            title: 'Services',
            subtitle: 'Browse pet services',
            icon: Icons.menu_rounded,
          ),
          const _PlaceholderTab(
            title: 'Rescue',
            subtitle: 'Emergency rescue — coming soon',
            icon: Icons.health_and_safety_outlined,
          ),
          const ProfileScreen(showBack: false),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        current: _tab,
        onChanged: (tab) => setState(() => _tab = tab),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.firstName,
    required this.fullName,
    required this.onOpenDrawer,
    required this.onOpenProfile,
  });

  final String firstName;
  final String fullName;
  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenProfile;

  static const _green = Color(0xFF17A855);

  static const _screenHorizontalPadding = 20.0;
  static const _sectionTitleGap = 16.0;
  static const _sectionGap = 32.0;
  static const _serviceGridSpacing = 12.0;
  static const _serviceCardVerticalPadding = 20.0;
  static const _serviceCardHeight =
      _serviceCardVerticalPadding * 2 + 50 + 8 + 18; // icon + label + gaps

  static final _listings = [
    const _BuySellItem(
      title: 'Labrador Pup',
      priceSar: 25000,
      emoji: '🐶',
      gradient: [Color(0xFFEDF9F1), Color(0xFFD8F0E2)],
    ),
    const _BuySellItem(
      title: 'Cockatiel',
      priceSar: 4500,
      emoji: '🐦',
      gradient: [Color(0xFFEFF6FF), Color(0xFFD9ECFF)],
    ),
    const _BuySellItem(
      title: 'Arabian Horse',
      priceSar: 180000,
      emoji: '🐴',
      gradient: [Color(0xFFFFF4EC), Color(0xFFFFE4D4)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                _screenHorizontalPadding,
                12,
                _screenHorizontalPadding,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeTopBar(
                    firstName: firstName,
                    fullName: fullName,
                    onOpenDrawer: onOpenDrawer,
                    onOpenProfile: onOpenProfile,
                  ),
                  const SizedBox(height: 18),
                  const _RescueBanner(),
                  const SizedBox(height: _sectionGap),
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: _sectionTitleGap),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: _serviceGridSpacing,
                    mainAxisSpacing: _serviceGridSpacing,
                    mainAxisExtent: _serviceCardHeight,
                    children: [
                      _ServiceCard(
                        label: 'Grooming',
                        icon: Icons.content_cut_rounded,
                        tint: const Color(0xFFE8F7EE),
                        iconColor: const Color(0xFFE25555),
                        onTap: () {},
                      ),
                      _ServiceCard(
                        label: 'Delivery',
                        icon: Icons.local_shipping_outlined,
                        tint: const Color(0xFFFFF0E6),
                        iconColor: const Color(0xFFE67E22),
                        onTap: () => context.push(RouteNames.rideRequest),
                      ),
                      _ServiceCard(
                        label: 'Boarding',
                        icon: Icons.other_houses_outlined,
                        tint: const Color(0xFFF3E8FF),
                        iconColor: const Color(0xFF8B5CF6),
                        onTap: () {},
                      ),
                      _ServiceCard(
                        label: 'Shower',
                        icon: Icons.bathtub_outlined,
                        tint: const Color(0xFFE8F4FF),
                        iconColor: const Color(0xFF3B82F6),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: _sectionGap),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Buy & Sell',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: _green,
                          padding: const EdgeInsets.only(left: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _sectionTitleGap),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 214,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: _HomeTab._screenHorizontalPadding,
                ),
                itemCount: _listings.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: _HomeTab._serviceGridSpacing),
                itemBuilder: (context, index) {
                  return _BuySellCard(item: _listings[index]);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({
    required this.firstName,
    required this.fullName,
    required this.onOpenDrawer,
    required this.onOpenProfile,
  });

  final String firstName;
  final String fullName;
  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenProfile;

  static const _green = Color(0xFF17A855);
  // Figma Dev Mode: 36×36, fill #F4FCF6, 1px #0F8A42 @ 55% border, #0F8A42 icon.
  static const _menuFill = Color(0xFFF4FCF6);
  static const _menuStroke = Color(0xFF0F8A42);
  static const _sideButtonSize = 36.0;

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Figma: menu + avatar on the edges, welcome block centered between them.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RoundIconButton(
          outlined: true,
          background: _menuFill,
          borderColor: _menuStroke.withValues(alpha: 0.55),
          icon: Icons.menu,
          iconColor: _menuStroke,
          size: _sideButtonSize,
          iconSize: 16,
          borderWidth: 1,
          onTap: onOpenDrawer,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome,',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                ),
                Text(
                  '$firstName 👋',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Material(
          color: _green,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onOpenProfile,
            child: SizedBox(
              width: _sideButtonSize,
              height: _sideButtonSize,
              child: Center(
                child: Text(
                  _initials(fullName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    this.background = Colors.transparent,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.size = 44,
    this.iconSize = 22,
    this.outlined = false,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  final Color background;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final bool outlined;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final strokeColor = borderColor ?? iconColor;
    final border = outlined
        ? BorderSide(color: strokeColor, width: borderWidth)
        : BorderSide.none;

    return Material(
      color: Colors.transparent,
      shape: CircleBorder(side: border),
      child: InkWell(
        customBorder: CircleBorder(side: border),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            border: outlined
                ? Border.all(color: strokeColor, width: borderWidth)
                : null,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: iconSize),
        ),
      ),
    );
  }
}

class _RescueBanner extends StatelessWidget {
  const _RescueBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF1F1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF5C2C2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.campaign_outlined, color: Color(0xFFC62828), size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Active rescue nearby — tap to help',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B1E1E),
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.label,
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Figma: icon tile + label centered in the white card.
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: _HomeTab._serviceCardHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: _HomeTab._serviceCardVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tint,
                      Color.lerp(tint, Colors.white, 0.35)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuySellItem {
  const _BuySellItem({
    required this.title,
    required this.priceSar,
    required this.emoji,
    required this.gradient,
  });

  final String title;
  final int priceSar;
  final String emoji;
  final List<Color> gradient;
}

class _BuySellCard extends StatelessWidget {
  const _BuySellCard({required this.item});

  final _BuySellItem item;

  static final _priceFormat = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    // Figma: white card · large gradient media · name + green price below.
    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: item.gradient,
                ),
              ),
              alignment: Alignment.center,
              child: Text(item.emoji, style: const TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'SAR ${_priceFormat.format(item.priceSar)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17A855),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppBottomNav.selectedColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
