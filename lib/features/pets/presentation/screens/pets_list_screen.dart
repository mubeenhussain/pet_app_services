import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/pets/presentation/providers/pets_controller.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_empty_state.dart';
import 'package:pet_app/shared/widgets/app_error_view.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

/// BRD 6.9 — My Pets List
class PetsListScreen extends ConsumerWidget {
  const PetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.yourPets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addPet),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addPet),
      ),
      body: petsAsync.when(
        loading: () => AppLoadingView(message: context.l10n.loading),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(petsListProvider),
        ),
        data: (pets) {
          if (pets.isEmpty) {
            return AppEmptyState(
              message: context.l10n.noPetsYet,
              actionLabel: context.l10n.addPet,
              onAction: () => context.push(RouteNames.addPet),
              icon: Icons.pets,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(pet.name.isNotEmpty ? pet.name[0] : '?'),
                  ),
                  title: Text(pet.name),
                  subtitle: Text('${pet.species}${pet.age != null ? ' · ${pet.age}y' : ''}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/pets/${pet.id}/edit'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
