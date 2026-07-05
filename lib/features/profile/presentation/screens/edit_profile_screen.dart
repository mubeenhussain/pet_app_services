import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// BRD 6.8 — Edit User Info
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _cityController = TextEditingController();
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final user = ref.read(currentUserProvider);
    _usernameController.text = user?.username ?? '';
    _cityController.text = user?.city ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await ref.read(authRepositoryProvider).updateUserProfile(
          user.copyWith(
            username: _usernameController.text.trim(),
            city: _cityController.text.trim(),
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.edit)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              controller: _usernameController,
              label: context.l10n.usernameHint,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _cityController,
              label: context.l10n.cityHint,
            ),
            const Spacer(),
            AppButton(label: context.l10n.save, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
