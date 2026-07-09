import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/rides/presentation/providers/ride_controller.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

/// BRD 6.37 — Searching For a Driver
class RideSearchingScreen extends ConsumerWidget {
  const RideSearchingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.searchingForDriver)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const AppLoadingView(),
            const SizedBox(height: 24),
            Text(
              context.l10n.searchingForDriver,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.cancel,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.go(RouteNames.home),
            ),
            AppButton(
              label: context.l10n.simulateDriverAllocated,
              onPressed: () => context.push(RouteNames.rideWaitDriver),
            ),
          ],
        ),
      ),
    );
  }
}
