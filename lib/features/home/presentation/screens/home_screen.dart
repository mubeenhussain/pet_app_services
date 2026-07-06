import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/providers/locale_provider.dart';
import 'package:pet_app/shared/widgets/app_drawer.dart';

/// BRD 6.13 — Home Page
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final l10n = context.l10n;
    final name = user?.username ?? l10n.guestUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
          ),
        ],
      ),
      drawer: AppDrawer(username: name),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.rideRequest),
        child: const Icon(Icons.local_shipping_outlined),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.homeGreeting(name),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _ServiceTile(
            icon: Icons.content_cut,
            label: 'Grooming',
            onTap: () {},
          ),
          _ServiceTile(
            icon: Icons.shower,
            label: 'Shower',
            onTap: () {},
          ),
          _ServiceTile(
            icon: Icons.local_shipping,
            label: l10n.requestRide,
            color: context.colorScheme.primary,
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
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
