import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/models/app_notification.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

class NotificationRepository {
  NotificationRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _notifications(String uid) =>
      _firestore.collection('users').doc(uid).collection('notifications');

  Stream<List<AppNotification>> watchUnread(String uid) {
    return _notifications(uid)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => AppNotification.fromMap(
                  doc.data(),
                  id: doc.id,
                  userId: uid,
                ),
              )
              .where((notification) => !notification.read)
              .toList(),
        );
  }

  Future<bool> hasWelcomeNotification(String uid) async {
    final snap = await _notifications(uid)
        .where('type', isEqualTo: 'welcome')
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<void> createWelcomeNotification({
    required String uid,
    required String title,
    required String body,
  }) async {
    final exists = await hasWelcomeNotification(uid);
    if (exists) return;

    await _notifications(uid).add({
      'type': 'welcome',
      'title': title,
      'body': body,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAsRead(String uid, String notificationId) {
    return _notifications(uid).doc(notificationId).update({'read': true});
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(firestoreProvider));
});
