import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.36 — Setup Payment (Ride)
class RidePaymentScreen extends ConsumerWidget {
  const RidePaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(rideDraftProvider);
    final isLoading = ref.watch(rideControllerProvider).isLoading;

    Future<void> pay() async {
      final user = ref.read(currentUserProvider);
      if (user == null || draft.petId == null) return;

      final dto = RideRequestDto(
        petId: draft.petId!,
        pickup: draft.pickup!,
        destination: draft.destination!,
        carType: draft.carType,
      );

      await ref.read(rideControllerProvider.notifier).submitRequest(
            userId: user.uid,
            dto: dto,
          );

      if (context.mounted) context.push(RouteNames.rideSearching);
    }

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.checkout)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Mada / Card'),
              subtitle: Text('Default payment method'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.confirmAndPay,
              isLoading: isLoading,
              onPressed: pay,
            ),
          ],
        ),
      ),
    );
  }
}
