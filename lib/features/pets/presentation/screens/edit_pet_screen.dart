import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/demo_pets.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/models/pet_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';
import 'package:pet_app/shared/widgets/field_label.dart';

const _speciesOptions = ['Dog', 'Cat', 'Bird', 'Other'];

/// BRD 6.11 — Edit Pet Info (Figma)
class EditPetScreen extends ConsumerStatefulWidget {
  const EditPetScreen({super.key, required this.petId});

  final String petId;

  @override
  ConsumerState<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  PetModel? _pet;
  String _species = 'Dog';
  String _gender = 'male';
  var _loading = true;
  var _saving = false;

  static const _green = Color(0xFF17A855);
  static const _deleteRed = Color(0xFFD32F2F);

  bool get _isDemo => isDemoPetId(widget.petId);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
    Future.microtask(_loadPet);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadPet() async {
    PetModel? pet;

    if (_isDemo) {
      final demo = ref.read(demoPetsProvider);
      for (final p in demo) {
        if (p.id == widget.petId) {
          pet = p;
          break;
        }
      }
    } else {
      final list = ref.read(petsListProvider).valueOrNull;
      if (list != null) {
        for (final p in list) {
          if (p.id == widget.petId) {
            pet = p;
            break;
          }
        }
      }
      pet ??= await ref.read(petsRepositoryProvider).getPet(widget.petId);
    }

    if (!mounted) return;

    if (pet == null) {
      setState(() => _loading = false);
      return;
    }

    _applyPet(pet);
    setState(() {
      _pet = pet;
      _loading = false;
    });
  }

  void _applyPet(PetModel pet) {
    _nameController.text = pet.name;
    _breedController.text = pet.breed ?? '';
    _ageController.text = pet.age?.toString() ?? '1';
    _species = _normalizeSpecies(pet.species);
    _gender = (pet.gender ?? 'male').toLowerCase() == 'female'
        ? 'female'
        : 'male';
  }

  String _normalizeSpecies(String raw) {
    final t = raw.trim().toLowerCase();
    if (t.contains('cat')) return 'Cat';
    if (t.contains('bird') || t.contains('parrot')) return 'Bird';
    if (t.contains('dog')) return 'Dog';
    if (_speciesOptions.map((e) => e.toLowerCase()).contains(t)) {
      return t[0].toUpperCase() + t.substring(1);
    }
    return 'Other';
  }

  String _emojiForSpecies(String species) {
    final key = species.toLowerCase();
    if (key.contains('cat')) return '🐱';
    if (key.contains('bird')) return '🐦';
    return '🐶';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existing = _pet;
    if (existing == null) return;

    setState(() => _saving = true);

    final updated = existing.copyWith(
      name: _nameController.text.trim(),
      species: _species,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      gender: _gender,
    );

    try {
      if (_isDemo) {
        final list = [...ref.read(demoPetsProvider)];
        final index = list.indexWhere((p) => p.id == widget.petId);
        if (index >= 0) {
          list[index] = updated;
          ref.read(demoPetsProvider.notifier).state = list;
        }
      } else {
        await ref.read(petsControllerProvider.notifier).update(updated);
      }
      if (mounted) {
        context.showAppSnackBar('Pet updated');
        context.pop();
      }
    } catch (e) {
      if (mounted) context.showAppSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Remove ${_pet?.name ?? 'this pet'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: _deleteRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) await _delete();
  }

  Future<void> _delete() async {
    setState(() => _saving = true);
    try {
      if (_isDemo) {
        final list = [...ref.read(demoPetsProvider)]
          ..removeWhere((p) => p.id == widget.petId);
        ref.read(demoPetsProvider.notifier).state = list;
      } else {
        await ref.read(petsControllerProvider.notifier).delete(widget.petId);
      }
      if (mounted) {
        context.showAppSnackBar('Pet deleted');
        context.pop();
      }
    } catch (e) {
      if (mounted) context.showAppSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FB),
        body: AppLoadingView(message: 'Loading...'),
      );
    }

    if (_pet == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    AuthCircleBackButton(),
                    Expanded(
                      child: Text(
                        'Edit Pet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              const Expanded(
                child: Center(child: Text('Pet not found')),
              ),
            ],
          ),
        ),
      );
    }

    final titleName = _nameController.text.trim().isEmpty
        ? _pet!.name
        : _nameController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
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
                      'Edit $titleName',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFE8F7EE),
                                    Color(0xFFF8F9FB),
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _emojiForSpecies(_species),
                                style: const TextStyle(fontSize: 44),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to change photo',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        controller: _nameController,
                        label: 'Name',
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            Validators.requiredField(v, field: 'Name'),
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel(label: 'Species'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final option in _speciesOptions)
                            _SpeciesChip(
                              label: option,
                              selected: _species == option,
                              onTap: () => setState(() => _species = option),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _breedController,
                        label: 'Breed',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _AgeField(controller: _ageController),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GenderToggle(
                              value: _gender,
                              onChanged: (v) => setState(() => _gender = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _SavePetButton(
                        isLoading: _saving,
                        onPressed: _saving ? null : _save,
                      ),
                      // Conditionally show Delete when pet is loaded.
                      if (_pet != null) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton.icon(
                            onPressed: _saving ? null : _confirmDelete,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: _deleteRed,
                              size: 18,
                            ),
                            label: const Text(
                              'Delete Pet',
                              style: TextStyle(
                                color: _deleteRed,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeciesChip extends StatelessWidget {
  const _SpeciesChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);
  static const _unselectedBg = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _green : _unselectedBg,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AgeField extends StatelessWidget {
  const _AgeField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel(label: 'Age'),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: '1',
            suffixText: 'yrs',
            suffixStyle: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderToggle extends StatelessWidget {
  const _GenderToggle({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  static const _green = Color(0xFF17A855);
  static const _track = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel(label: 'Gender'),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: _track,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: _GenderSegment(
                  label: 'Male',
                  selected: value == 'male',
                  onTap: () => onChanged('male'),
                ),
              ),
              Expanded(
                child: _GenderSegment(
                  label: 'Female',
                  selected: value == 'female',
                  onTap: () => onChanged('female'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenderSegment extends StatelessWidget {
  const _GenderSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _green : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SavePetButton extends StatelessWidget {
  const _SavePetButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
            : const Text(
                'Save Pet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
