import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// BRD 7.1 — Pending Driver Requests
class PendingDriverRequestsScreen extends ConsumerWidget {
  const PendingDriverRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending driver requests')),
      body: const Center(
        child: Text('Connect to allocateDriver Cloud Function + SQL rides queue.'),
      ),
    );
  }
}
