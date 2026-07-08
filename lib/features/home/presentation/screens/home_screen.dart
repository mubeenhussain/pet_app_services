import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/locale_provider.dart';
import 'package:pet_app/shared/widgets/app_bottom_nav.dart';
import 'package:pet_app/shared/widgets/app_drawer.dart';

/// BRD 6.13 — Home shell with Figma bottom navigation.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  AppBottomTab _tab = AppBottomTab.home;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final l10n = context.l10n;
    final name = user?.username ?? l10n.guestUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _tab == AppBottomTab.home ? AppDrawer(username: name) : null,
      appBar: _tab == AppBottomTab.home
          ? AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.translate),
                  onPressed: () =>
                      ref.read(localeProvider.notifier).toggleLocale(),
                ),
              ],
            )
          : null,
      floatingActionButton: _tab == AppBottomTab.home
          ? FloatingActionButton(
              onPressed: () => context.push(RouteNames.rideRequest),
              child: const Icon(Icons.local_shipping_outlined),
            )
          : null,
      body: IndexedStack(
        index: _tab.index,
        children: [
          _HomeTab(
            name: name,
            greeting: l10n.homeGreeting(name),
            requestRideLabel: l10n.requestRide,
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
    required this.name,
    required this.greeting,
    required this.requestRideLabel,
  });

  final String name;
  final String greeting;
  final String requestRideLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        const _ServiceTile(
          icon: Icons.content_cut,
          label: 'Grooming',
        ),
        const _ServiceTile(
          icon: Icons.shower,
          label: 'Shower',
        ),
        _ServiceTile(
          icon: Icons.local_shipping,
          label: requestRideLabel,
          color: Theme.of(context).colorScheme.primary,
          onTap: () => context.push(RouteNames.rideRequest),
        ),
        const SizedBox(height: 16),
        Card(
          color: context.colors.emergency.withValues(alpha: 0.08),
          child: ListTile(
            leading: Icon(Icons.emergency, color: context.colors.emergency),
            title: const Text('Emergency vet clinics'),
            subtitle: const Text('Coming in Phase 3'),
            onTap: () {},
          ),
        ),
      ],
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

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap ?? () {},
      ),
    );
  }
}
