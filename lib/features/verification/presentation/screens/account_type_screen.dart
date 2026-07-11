import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/l10n/l10n_helpers.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/features/verification/data/verification_service.dart';
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
              title: Text(context.l10n.userRoleLabel(role)),
              trailing: role.needsVerification
                  ? const Icon(Icons.verified_user_outlined)
                  : null,
              onTap: () {
                if (role.needsVerification) {
                  ref.read(selectedVerificationRoleProvider.notifier).state =
                      role;
                  context.push(RouteNames.documentUpload);
                }
              },
            ),
        ],
      ),
    );
  }
}
