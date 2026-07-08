import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/models/user_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.7 — Display User Info (Figma: Profile)
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
        backgroundColor: AppColors.background,
        appBar: AppTopBar(title: Text(context.l10n.userSettings)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person_outline, size: 40, color: Colors.white),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profile == null
          ? Center(child: Text(context.l10n.errorGeneric))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.chevron_left_rounded,
                          onPressed: () => context.pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _CircleIconButton(
                          icon: Icons.edit_outlined,
                          onPressed: () => context.push(RouteNames.editProfile),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          _initials(profile.username),
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.username,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (profile.memberSinceYear != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Member since ${profile.memberSinceYear}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _InfoCard(
                      icon: Icons.phone_outlined,
                      label: 'PHONE',
                      value: profile.phone.isEmpty ? '-' : profile.phone,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.location_on_outlined,
                      label: 'CITY',
                      value: profile.city?.trim().isNotEmpty == true
                          ? profile.city!
                          : '-',
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.mail_outline_rounded,
                      label: 'EMAIL',
                      value: profile.email?.trim().isNotEmpty == true
                          ? profile.email!
                          : '-',
                    ),
                    const SizedBox(height: 28),
                    _EditProfileButton(
                      onPressed: () => context.push(RouteNames.editProfile),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Style tokens from Figma inspector (borders / colors / radius only).
abstract final class _ProfileTokens {
  static const cardRadius = 10.0;
  static const cardBorderWidth = 0.8;
  static const cardBorder = Color(0xFFDDEFE2);
  static const cardFill = Color(0xFFFFFFFF);

  static const editRadius = 10.0;
  static const editBorderWidth = 0.5;
  static const editBorder = Color(0xFF17A855);
  static const editForeground = Color(0xFF17A855);
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _ProfileTokens.cardFill,
        borderRadius: BorderRadius.circular(_ProfileTokens.cardRadius),
        border: Border.all(
          color: _ProfileTokens.cardBorder,
          width: _ProfileTokens.cardBorderWidth,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _ProfileTokens.editForeground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _ProfileTokens.editBorder,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: _ProfileTokens.editForeground),
        ),
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onPressed});

  final VoidCallback onPressed;

  // Figma properties exactly:
  // Fill width | H 48 | R 10 | stroke 0.5 Inner #17A855 | no fill
  static const _border = Color(0xFF17A855);
  static const _label = Color(0xFF17A855);
  static const _height = 48.0;
  static const _radius = 10.0;
  static const _borderWidth = 0.5;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Keep stroke as true 0.5 logical px; avoid Border which thickens thin lines.
    final stroke = _borderWidth;

    return SizedBox(
      width: double.infinity,
      height: _height,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_radius),
          splashColor: _border.withValues(alpha: 0.08),
          highlightColor: _border.withValues(alpha: 0.04),
          child: CustomPaint(
            // isComplex + willChange false keeps thin line crisp
            painter: _FigmaInnerStrokePainter(
              color: _border,
              strokeWidth: stroke,
              radius: _radius,
              devicePixelRatio: dpr,
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: _label),
                  SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _label,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Matches Figma "Inner" alignment stroke (not Flutter BoxDecoration border).
class _FigmaInnerStrokePainter extends CustomPainter {
  const _FigmaInnerStrokePainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.devicePixelRatio,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    // Align stroke to physical pixels so 0.5 logical doesn't become ~1px fuzzy.
    final physicalStroke = strokeWidth * devicePixelRatio;
    final alignedLogical = physicalStroke.round().clamp(1, 100) / devicePixelRatio;

    final inset = alignedLogical / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - alignedLogical,
      size.height - alignedLogical,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular((radius - inset).clamp(0, radius)),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = alignedLogical
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _FigmaInnerStrokePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.devicePixelRatio != devicePixelRatio;
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
