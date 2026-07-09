import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.38 — Wait For Driver
class RideWaitDriverScreen extends ConsumerWidget {
  const RideWaitDriverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(rideDraftProvider);

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.driverAllocated)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Ahmed Al-Rashid'),
                subtitle: const Text('Toyota Hiace · ABC 1234'),
              ),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.trackRide,
              onPressed: () {
                if (draft.rideId != null) {
                  context.push('/rides/status/${draft.rideId}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
