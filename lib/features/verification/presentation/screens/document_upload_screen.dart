import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/features/verification/data/verification_service.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

/// BRD 6.53 — Document Upload
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  String? _errorMessage;

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    final role = ref.read(selectedVerificationRoleProvider);

    if (user == null || user.uid.startsWith('local_')) {
      setState(() => _errorMessage = context.l10n.errorGeneric);
      return;
    }
    if (role == null) {
      setState(() => _errorMessage = context.l10n.accountType);
      return;
    }

    setState(() => _errorMessage = null);

    try {
      await ref.read(verificationControllerProvider.notifier).submit(
            userId: user.uid,
            accountType: role,
            documentUrl: 'pending_upload',
          );
      if (!mounted) return;
      context.showAppSnackBar(context.l10n.verificationSubmitted, isSuccess: true);
      context.push(RouteNames.verificationStatus);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = context.l10n.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(verificationControllerProvider).isLoading;

    return Scaffold(
      appBar: AppTopBar(title: Text(context.l10n.documentUpload)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_errorMessage != null) ...[
              AppFeedbackBanner(message: _errorMessage!),
              const SizedBox(height: 12),
            ],
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload_file, size: 40),
                  const SizedBox(height: 8),
                  Text(context.l10n.uploadLicenseHint),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.submit,
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
