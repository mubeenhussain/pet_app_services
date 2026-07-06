import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/models/ride_model.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_empty_state.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:pet_app/shared/widgets/app_loading.dart';

/// BRD 6.12 — Service History
class ServiceHistoryScreen extends ConsumerStatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  ConsumerState<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends ConsumerState<ServiceHistoryScreen> {
  var _loading = true;
  var _items = <RideModel>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final rides = await ref.read(ridesRepositoryProvider).getUserRides(user.uid);
    setState(() {
      _items = rides;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.orders)),
      body: _loading
          ? AppLoadingView(message: context.l10n.loading)
          : _items.isEmpty
              ? AppEmptyState(message: 'No orders yet', icon: Icons.receipt_long)
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final ride = _items[index];
                    return ListTile(
                      title: Text('Ride · ${ride.status.label}'),
                      subtitle: Text('${ride.pickup} → ${ride.destination}'),
                    );
                  },
                ),
    );
  }
}
