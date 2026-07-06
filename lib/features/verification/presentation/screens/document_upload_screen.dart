import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.53 — Document Upload
class DocumentUploadScreen extends ConsumerWidget {
  const DocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.documentUpload)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 40),
                  SizedBox(height: 8),
                  Text('Upload license / ID documents'),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.submit,
              onPressed: () => context.push(RouteNames.verificationStatus),
            ),
          ],
        ),
      ),
    );
  }
}
