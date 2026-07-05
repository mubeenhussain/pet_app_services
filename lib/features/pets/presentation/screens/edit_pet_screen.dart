import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// BRD 6.11 — Edit Pet Info
class EditPetScreen extends ConsumerStatefulWidget {
  const EditPetScreen({super.key, required this.petId});

  final String petId;

  @override
  ConsumerState<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  Future<void> _loadPet() async {
    final pet = await ref.read(petsRepositoryProvider).getPet(widget.petId);
    if (pet != null && mounted) {
      _nameController.text = pet.name;
      _speciesController.text = pet.species;
      setState(() => _loaded = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existing = await ref.read(petsRepositoryProvider).getPet(widget.petId);
    if (existing == null) return;

    await ref.read(petsControllerProvider.notifier).update(
          existing.copyWith(
            name: _nameController.text.trim(),
            species: _speciesController.text.trim(),
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    await ref.read(petsControllerProvider.notifier).delete(widget.petId);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.edit)),
        body: AppLoadingView(message: context.l10n.loading),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.edit)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                label: context.l10n.petName,
                validator: (v) => Validators.requiredField(v, field: 'Name'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _speciesController,
                label: context.l10n.species,
                validator: (v) => Validators.requiredField(v, field: 'Species'),
              ),
              const SizedBox(height: 24),
              AppButton(label: context.l10n.save, onPressed: _save),
              const SizedBox(height: 12),
              AppButton(
                label: context.l10n.delete,
                variant: AppButtonVariant.outlined,
                onPressed: _delete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
