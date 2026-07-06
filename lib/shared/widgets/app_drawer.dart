import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.username});

  final String username;

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(username),
                  accountEmail: Text(context.l10n.userSettings),
                  currentAccountPicture:
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(context.l10n.userSettings),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.profile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text(context.l10n.yourPets),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.pets);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(context.l10n.orders),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.orders);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(context.l10n.accountType),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.accountType);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _logout(context, ref),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
