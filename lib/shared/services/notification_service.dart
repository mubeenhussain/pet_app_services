import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService._();

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    // FCM token registration handled after auth in Phase 1 integration.
  }
}
