import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';

/// BRD 6.7 — Display User Info
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.userSettings)),
      body: user == null
          ? Center(child: Text(context.l10n.errorGeneric))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(user.username.isNotEmpty ? user.username[0] : '?'),
                  ),
                  const SizedBox(height: 16),
                  Text(user.username, style: Theme.of(context).textTheme.titleLarge),
                  Text(user.phone),
                  if (user.city != null) Text(user.city!),
                  const Spacer(),
                  AppButton(
                    label: context.l10n.edit,
                    onPressed: () => context.push(RouteNames.editProfile),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Sign out',
                    variant: AppButtonVariant.outlined,
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              ),
            ),
    );
  }
}
