import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/models/app_notification.dart';
import 'package:pet_app/shared/services/notification_repository.dart';
import 'package:pet_app/shared/services/welcome_notification_service.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';

class WelcomeNotificationBanner extends ConsumerWidget {
  const WelcomeNotificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(unreadNotificationsProvider).valueOrNull;
    final welcome = notifications
        ?.where((notification) => notification.type == AppNotificationType.welcome)
        .firstOrNull;

    if (welcome == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppFeedbackBanner(
        variant: AppFeedbackVariant.success,
        message: welcome.body.isNotEmpty
            ? welcome.body
            : context.l10n.welcomeNotificationBody,
        icon: Icons.celebration_outlined,
        trailing: TextButton(
          onPressed: () => _dismiss(context, ref, welcome.id, welcome.userId),
          child: Text(context.l10n.dismiss),
        ),
      ),
    );
  }

  Future<void> _dismiss(
    BuildContext context,
    WidgetRef ref,
    String notificationId,
    String userId,
  ) async {
    if (notificationId == 'local_welcome' || userId.startsWith('local_')) {
      await ref.read(welcomeNotificationServiceProvider).clearLocalPendingWelcome();
      ref.invalidate(unreadNotificationsProvider);
      return;
    }

    await ref
        .read(notificationRepositoryProvider)
        .markAsRead(userId, notificationId);
  }
}
