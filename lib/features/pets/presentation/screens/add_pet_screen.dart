import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/models/pet_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';

/// BRD 6.10 — Add Pet
class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final pet = PetModel(
      id: '',
      ownerId: user.uid,
      name: _nameController.text.trim(),
      species: _speciesController.text.trim(),
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      gender: _gender,
    );

    await ref.read(petsControllerProvider.notifier).create(pet);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(petsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.addPet)),
      body: SingleChildScrollView(
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
              const SizedBox(height: 16),
              AppTextField(
                controller: _breedController,
                label: context.l10n.breed,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _ageController,
                label: context.l10n.age,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'male', label: Text('Male')),
                  ButtonSegment(value: 'female', label: Text('Female')),
                ],
                selected: {_gender},
                onSelectionChanged: (value) => setState(() => _gender = value.first),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: context.l10n.save,
                isLoading: isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
