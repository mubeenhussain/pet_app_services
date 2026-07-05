import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(context.l10n.userSettings),
            currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
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
    );
  }
}
