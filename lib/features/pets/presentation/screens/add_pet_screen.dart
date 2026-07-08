import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/models/pet_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';
import 'package:pet_app/shared/widgets/field_label.dart';

const _speciesOptions = ['Dog', 'Cat', 'Bird', 'Other'];

/// BRD 6.10 — Add Pet (Figma)
class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController(text: '1');

  String _species = 'Dog';
  String _gender = 'male';
  var _saving = false;

  static const _green = Color(0xFF17A855);

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    final cached = ref.read(cachedUserProfileProvider).valueOrNull;
    final ownerId = user?.uid ?? cached?.uid;
    if (ownerId == null || ownerId.isEmpty) {
      context.showAppSnackBar('Please sign in to save a pet', isError: true);
      return;
    }

    setState(() => _saving = true);

    final pet = PetModel(
      id: '',
      ownerId: ownerId,
      name: _nameController.text.trim(),
      species: _species,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      gender: _gender,
    );

    try {
      await ref.read(petsControllerProvider.notifier).create(pet);
      if (mounted) {
        context.showAppSnackBar('Pet saved');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.showAppSnackBar(e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _saving || ref.watch(petsControllerProvider).isLoading;

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
                      'Add New Pet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
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
                      const _AddPhotoButton(),
                      const SizedBox(height: 28),
                      AppTextField(
                        controller: _nameController,
                        label: 'Name',
                        hint: 'e.g. Buddy',
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
                        hint: 'e.g. Golden Retriever',
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
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _save,
                      ),
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

class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton();

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              context.showAppSnackBar('Photo upload coming soon');
            },
            child: SizedBox(
              width: 88,
              height: 88,
              child: CustomPaint(
                painter: const _DashedCirclePainter(
                  color: Color(0xFFB7E0C7),
                  strokeWidth: 1.5,
                ),
                child: const Center(
                  child: Icon(
                    Icons.photo_camera_outlined,
                    color: _green,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Add Photo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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

  // Figma-aligned with Save Changes: radius 10, height 46, #17A855
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

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      const dash = 5.0;
      const gap = 4.0;
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
