import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/models/user_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
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
    final cached = ref.watch(cachedUserProfileProvider).valueOrNull;

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

    final profile = _ProfileViewData.fromSources(user: user, cached: cached);
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: profile == null
          ? Center(child: Text(context.l10n.errorGeneric))
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _ActionCircleButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.userSettings,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _ActionCircleButton(
                          icon: Icons.edit_outlined,
                          onPressed: () => context.push(RouteNames.editProfile),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 38,
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.18),
                      child: Text(
                        _initials(profile.username),
                        style: context.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      profile.username,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (profile.memberSinceYear != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Member since ${profile.memberSinceYear}',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _InfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: profile.phone.isEmpty ? '-' : profile.phone,
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'City',
                      value: profile.city?.trim().isNotEmpty == true
                          ? profile.city!
                          : '-',
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email?.trim().isNotEmpty == true
                          ? profile.email!
                          : '-',
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Edit Profile',
                      variant: AppButtonVariant.outlined,
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
            ),
    );
  }
}

class _ProfileViewData {
  const _ProfileViewData({
    required this.username,
    required this.phone,
    this.email,
    this.city,
    this.memberSinceYear,
  });

  final String username;
  final String phone;
  final String? email;
  final String? city;
  final int? memberSinceYear;

  static _ProfileViewData? fromSources({
    required UserModel? user,
    required CachedUserProfile? cached,
  }) {
    if (user != null) {
      return _ProfileViewData(
        username: user.username,
        phone: user.phone,
        email: user.email,
        city: user.city,
        memberSinceYear: user.createdAt?.year,
      );
    }

    if (cached == null) return null;
    return _ProfileViewData(
      username: cached.username,
      phone: cached.phone,
      email: cached.email,
      city: cached.city,
      memberSinceYear: cached.createdAtYear,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  const _ActionCircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
        backgroundColor: colorScheme.primary.withValues(alpha: 0.06),
        minimumSize: const Size(34, 34),
        fixedSize: const Size(34, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.characters.take(1).toString();
  return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}';
}
