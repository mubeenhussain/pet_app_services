import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum AppNotificationType { welcome, general }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.read = false,
    this.createdAt,
  });

  final String id;
  final String userId;
  final AppNotificationType type;
  final String title;
  final String body;
  final bool read;
  final DateTime? createdAt;

  factory AppNotification.fromMap(
    Map<String, dynamic> map, {
    required String id,
    required String userId,
  }) {
    final typeRaw = map['type'] as String? ?? 'general';
    return AppNotification(
      id: id,
      userId: userId,
      type: typeRaw == 'welcome'
          ? AppNotificationType.welcome
          : AppNotificationType.general,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      read: map['read'] as bool? ?? false,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type == AppNotificationType.welcome ? 'welcome' : 'general',
      'title': title,
      'body': body,
      'read': read,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props => [id, userId, type, title, read];
}
