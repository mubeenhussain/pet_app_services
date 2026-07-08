import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/providers/demo_pets.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/models/pet_model.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

/// BRD 6.9 — My Pets List (Figma)
class PetsListScreen extends ConsumerWidget {
  const PetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsListProvider);
    final demoPets = ref.watch(demoPetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const _MyPetsHeader(),
            Expanded(
              child: petsAsync.when(
                loading: () => const AppLoadingView(message: 'Loading...'),
                error: (_, __) => _PetsGrid(pets: demoPets),
                data: (pets) => _PetsGrid(
                  pets: pets.isEmpty ? demoPets : pets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPetsHeader extends StatelessWidget {
  const _MyPetsHeader();

  static const _green = Color(0xFF17A855);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          const AuthCircleBackButton(),
          const Expanded(
            child: Text(
              'My Pets',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Material(
            color: _green,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(RouteNames.addPet),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetsGrid extends StatelessWidget {
  const _PetsGrid({required this.pets});

  final List<PetModel> pets;

  @override
  Widget build(BuildContext context) {
    final itemCount = pets.length + 1;
    final width = MediaQuery.sizeOf(context).width;

    // Responsive side padding + gutters scaled from Figma (~20 / 16 / 24).
    final horizontalPadding = (width * 0.053).clamp(16.0, 24.0);
    final crossSpacing = (width * 0.042).clamp(12.0, 20.0);
    final mainSpacing = (crossSpacing * 1.35).clamp(16.0, 28.0);

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        24,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: crossSpacing,
        mainAxisSpacing: mainSpacing,
        childAspectRatio: 0.88,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == pets.length) {
          return _AddNewPetCard(
            onTap: () => context.push(RouteNames.addPet),
          );
        }

        final pet = pets[index];
        return _PetCard(
          pet: pet,
          onTap: () => context.push('/pets/${pet.id}/edit'),
        );
      },
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet, required this.onTap});

  final PetModel pet;
  final VoidCallback onTap;

  // Figma: radius 16, white card, soft shadow
  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    final style = _PetVisuals.fromSpecies(pet.species);
    final subtitle = pet.age == null
        ? _titleCase(pet.species)
        : '${_titleCase(pet.species)} · ${pet.age} ${pet.age == 1 ? 'yr' : 'yrs'}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: style.gradient,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    style.emoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pet.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _titleCase(String value) {
    final t = value.trim();
    if (t.isEmpty) return 'Pet';
    return t[0].toUpperCase() + t.substring(1).toLowerCase();
  }
}

class _AddNewPetCard extends StatelessWidget {
  const _AddNewPetCard({required this.onTap});

  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);
  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomPaint(
            painter: const _DashedRRectPainter(
              color: _green,
              strokeWidth: 1.5,
              radius: _radius,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: _green, width: 1.5),
                        ),
                      ),
                      child: Icon(Icons.add, color: _green, size: 22),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add New Pet',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _green,
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

class _PetVisuals {
  const _PetVisuals({required this.emoji, required this.gradient});

  final String emoji;
  final List<Color> gradient;

  /// Figma colors + emoji (no extra icon package needed).
  static _PetVisuals fromSpecies(String species) {
    final key = species.trim().toLowerCase();
    if (key.contains('cat')) {
      return const _PetVisuals(
        emoji: '🐱',
        gradient: [Color(0xFFFFF4EC), Color(0xFFFFE4D4)],
      );
    }
    if (key.contains('bird') || key.contains('parrot')) {
      return const _PetVisuals(
        emoji: '🐦',
        gradient: [Color(0xFFEFF6FF), Color(0xFFD9ECFF)],
      );
    }
    return const _PetVisuals(
      emoji: '🐶',
      gradient: [Color(0xFFEDF9F1), Color(0xFFD8F0E2)],
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
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
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
