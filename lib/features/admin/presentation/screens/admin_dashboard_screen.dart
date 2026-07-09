import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/router/route_names.dart';

/// Admin dashboard — Phase 1 subset (BRD Section 7)
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.adminDashboard)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(title: context.l10n.pendingRides, value: '—'),
          _StatCard(title: context.l10n.pendingVerifications, value: '—'),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(context.l10n.pendingDriverRequests),
            onTap: () => context.push(RouteNames.adminPendingDrivers),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(title: Text(title), trailing: Text(value)),
    );
  }
}
