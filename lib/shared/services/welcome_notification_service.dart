import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/constants/storage_keys.dart';
import 'package:pet_app/shared/models/app_notification.dart';
import 'package:pet_app/shared/providers/app_providers.dart';
import 'package:pet_app/shared/services/local_storage_service.dart';
import 'package:pet_app/shared/services/notification_repository.dart';

/// BRD — welcome in-app notification on first login.
class WelcomeNotificationService {
  WelcomeNotificationService({
    required NotificationRepository notifications,
    required LocalStorageService storage,
  })  : _notifications = notifications,
        _storage = storage;

  final NotificationRepository _notifications;
  final LocalStorageService _storage;

  Future<void> ensureWelcome({
    required String uid,
    required String title,
    required String body,
  }) async {
    if (uid.startsWith('local_')) {
      final shown = await _storage.read('${StorageKeys.welcomeShownPrefix}$uid');
      if (shown == 'true') return;
      await _storage.write('${StorageKeys.welcomeShownPrefix}$uid', 'true');
      await _storage.write(StorageKeys.pendingWelcomeTitle, title);
      await _storage.write(StorageKeys.pendingWelcomeBody, body);
      return;
    }

    await _notifications.createWelcomeNotification(
      uid: uid,
      title: title,
      body: body,
    );
  }

  Future<({String title, String body})?> readLocalPendingWelcome() async {
    final title = await _storage.read(StorageKeys.pendingWelcomeTitle);
    final body = await _storage.read(StorageKeys.pendingWelcomeBody);
    if (title == null || body == null) return null;
    return (title: title, body: body);
  }

  Future<void> clearLocalPendingWelcome() async {
    await _storage.remove(StorageKeys.pendingWelcomeTitle);
    await _storage.remove(StorageKeys.pendingWelcomeBody);
  }
}

final welcomeNotificationServiceProvider = Provider<WelcomeNotificationService>(
  (ref) {
    return WelcomeNotificationService(
      notifications: ref.watch(notificationRepositoryProvider),
      storage: ref.watch(localStorageProvider),
    );
  },
);

final unreadNotificationsProvider =
    StreamProvider<List<AppNotification>>((ref) async* {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.uid.startsWith('local_')) {
    final welcome = await ref
        .watch(welcomeNotificationServiceProvider)
        .readLocalPendingWelcome();
    if (welcome != null) {
      yield [
        AppNotification(
          id: 'local_welcome',
          userId: user?.uid ?? 'local',
          type: AppNotificationType.welcome,
          title: welcome.title,
          body: welcome.body,
        ),
      ];
    } else {
      yield const [];
    }
    return;
  }

  yield* ref
      .watch(notificationRepositoryProvider)
      .watchUnread(user.uid);
});
