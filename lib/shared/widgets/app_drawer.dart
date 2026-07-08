import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

/// HOME-side-bar (Figma)
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.username});

  final String username;

  static const _green = Color(0xFF17A855);
  static const _headerBg = Color(0xFFF3FAF5);
  static const _iconColor = Color(0xFF1A1A2E);

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) {
      context.go(RouteNames.login);
    }
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}'
        .toUpperCase();
  }

  String _formatPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '';
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return digits;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final cached = ref.watch(cachedUserProfileProvider).valueOrNull;
    final displayName =
        (user?.username.isNotEmpty == true ? user!.username : null) ??
            (cached?.username.isNotEmpty == true ? cached!.username : null) ??
            username;
    final phone = _formatPhone(user?.phone ?? cached?.phone);

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: _headerBg,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _green,
                    child: Text(
                      _initials(displayName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: 'User Settings',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.profile);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.pets_outlined,
                    label: 'Your Pets',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.pets);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Messages',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.messages);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Orders',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.orders);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.shield_outlined,
                    label: 'Account Type',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.accountType);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment Methods',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.ridePayment);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE8EAEF)),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () => _logout(context, ref),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _iconColor = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: _iconColor, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      minLeadingWidth: 28,
    );
  }
}
