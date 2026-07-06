import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.52 — Account Type Selection
class AccountTypeScreen extends ConsumerWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.accountType)),
      body: ListView(
        children: [
          for (final role in [
            UserRole.petOwner,
            UserRole.seller,
            UserRole.provider,
            UserRole.houser,
            UserRole.clinic,
          ])
            ListTile(
              title: Text(role.value),
              trailing: role.needsVerification
                  ? const Icon(Icons.verified_user_outlined)
                  : null,
              onTap: () {
                if (role.needsVerification) {
                  context.push(RouteNames.documentUpload);
                }
              },
            ),
        ],
      ),
    );
  }
}
