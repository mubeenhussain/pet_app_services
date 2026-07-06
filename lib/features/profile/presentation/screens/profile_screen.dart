import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.7 — Display User Info
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authStateProvider).valueOrNull;
    final isGuest = session?.isGuest ?? false;
    final user = ref.watch(currentUserProvider);

    if (isGuest) {
      return Scaffold(
        appBar: AppTopBar(title: Text(context.l10n.userSettings)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person_outline, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.guestUser,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.guestProfileMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              AppButton(
                label: context.l10n.logout,
                variant: AppButtonVariant.outlined,
                onPressed: () => _logout(context, ref),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.userSettings)),
      body: user == null
          ? Center(child: Text(context.l10n.errorGeneric))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      user.username.isNotEmpty ? user.username[0] : '?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(user.phone),
                  if (user.city != null) Text(user.city!),
                  const Spacer(),
                  AppButton(
                    label: context.l10n.edit,
                    onPressed: () => context.push(RouteNames.editProfile),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: context.l10n.logout,
                    variant: AppButtonVariant.outlined,
                    onPressed: () => _logout(context, ref),
                  ),
                ],
              ),
            ),
    );
  }
}
