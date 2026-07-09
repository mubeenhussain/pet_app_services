import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';
import 'package:pet_app/shared/widgets/app_select_field.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';
import 'package:pet_app/shared/widgets/phone_field.dart';

/// BRD 6.8 — Edit User Info (Figma: Edit Profile)
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedCity;
  var _initialized = false;
  var _saving = false;

  List<String> _localizedCities(BuildContext context) => [
        context.l10n.cityRiyadh,
        context.l10n.cityJeddah,
        context.l10n.cityMecca,
        context.l10n.cityMedina,
        context.l10n.cityDammam,
        context.l10n.cityKhobar,
        context.l10n.cityTabuk,
        context.l10n.cityAbha,
        context.l10n.cityDubai,
        context.l10n.cityLahore,
      ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final user = ref.read(currentUserProvider);
    final cached = ref.read(cachedUserProfileProvider).valueOrNull;

    final name = user?.username ?? cached?.username ?? '';
    final phone = user?.phone ?? cached?.phone ?? '';
    final email = user?.email ?? cached?.email ?? '';
    final city = user?.city ?? cached?.city;

    _nameController.text = name;
    _phoneController.text = _stripDialCode(phone);
    _emailController.text = email.startsWith('phone_') ? '' : email;
    _selectedCity = (city != null && city.trim().isNotEmpty) ? city : null;

    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _stripDialCode(String phone) {
    var value = phone.replaceAll(RegExp(r'\s+'), '');
    if (value.startsWith('+966')) value = value.substring(4);
    if (value.startsWith('966')) value = value.substring(3);
    if (value.startsWith('0')) value = value.substring(1);
    return value;
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

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    final cached = ref.read(cachedUserProfileProvider).valueOrNull;
    if (user == null && cached == null) return;

    setState(() => _saving = true);

    final name = _nameController.text.trim();
    final phoneLocal = _phoneController.text.trim();
    final phone = PhoneAuthService.normalizePhone(phoneLocal);
    final email = _emailController.text.trim();
    final city = _selectedCity?.trim() ?? '';

    try {
      if (user != null) {
        final updated = user.copyWith(
          username: name,
          phone: phone,
          email: email.isEmpty ? user.email : email,
          city: city,
        );
        await ref.read(authRepositoryProvider).updateUserProfile(updated);
        await ref.read(localStorageProvider).saveCachedUserProfile(
              CachedUserProfile(
                uid: updated.uid,
                username: updated.username,
                phone: updated.phone,
                email: updated.email,
                city: updated.city,
                createdAtYear: updated.createdAt?.year,
              ),
            );
      } else if (cached != null) {
        await ref.read(localStorageProvider).saveCachedUserProfile(
              CachedUserProfile(
                uid: cached.uid,
                username: name,
                phone: phone,
                email: email.isEmpty ? cached.email : email,
                city: city,
                createdAtYear: cached.createdAtYear,
              ),
            );
      }

      ref.invalidate(cachedUserProfileProvider);
      ref.invalidate(authStateProvider);

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localizedCities = _localizedCities(context);
    final displayName = _nameController.text.trim().isEmpty
        ? l10n.userFallback
        : _nameController.text.trim();

    final cityItems = [
      ...localizedCities,
      if (_selectedCity != null && !localizedCities.contains(_selectedCity))
        _selectedCity!,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const AuthCircleBackButton(),
                  Expanded(
                    child: Text(
                      l10n.editProfile,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 96,
                            height: 96,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 48,
                                  backgroundColor: const Color(0xFF17A855),
                                  child: Text(
                                    _initials(displayName),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Material(
                                    color: Colors.white,
                                    shape: const CircleBorder(
                                      side: BorderSide(
                                        color: Color(0xFF17A855),
                                        width: 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        context.showAppSnackBar(
                                          l10n.photoUpdateSoon,
                                        );
                                      },
                                      child: const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: Icon(
                                          Icons.photo_camera_outlined,
                                          size: 16,
                                          color: Color(0xFF17A855),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.tapChangePhoto,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      controller: _nameController,
                      label: l10n.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 18),
                    PhoneField(
                      controller: _phoneController,
                      label: l10n.phone,
                      hint: l10n.phonePlaceholder,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 18),
                    AppSelectField<String>(
                      label: l10n.cityHint,
                      hint: l10n.selectCity,
                      value: _selectedCity,
                      items: cityItems,
                      itemLabel: (c) => c,
                      onChanged: (city) =>
                          setState(() => _selectedCity = city),
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32),
                    _SaveChangesButton(
                      isLoading: _saving,
                      onPressed: _saving ? null : _save,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  const _SaveChangesButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  // Figma: fill width | H 46 | R 10 | fill #17A855
  // Drop shadow: X0 Y1 Blur 4.1 Spread -8 #0F8A42 @ 55%
  static const _green = Color(0xFF17A855);
  static const _shadow = Color(0xFF0F8A42);
  static const _height = 46.0;
  static const _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: _shadow.withValues(alpha: 0.55),
            offset: const Offset(0, 1),
            blurRadius: 4.1,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                context.l10n.saveChanges,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
