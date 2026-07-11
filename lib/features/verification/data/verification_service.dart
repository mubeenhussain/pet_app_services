import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/shared/enums/user_role.dart';
import 'package:pet_app/shared/providers/app_providers.dart';

class VerificationRequestModel {
  const VerificationRequestModel({
    required this.id,
    required this.userId,
    required this.accountType,
    required this.status,
    this.documentUrl,
    this.createdAt,
  });

  final String id;
  final String userId;
  final UserRole accountType;
  final String status;
  final String? documentUrl;
  final DateTime? createdAt;

  factory VerificationRequestModel.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return VerificationRequestModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      accountType: UserRole.fromValue(
        map['accountType'] as String? ?? UserRole.seller.value,
      ),
      status: map['status'] as String? ?? 'pending',
      documentUrl: map['documentUrl'] as String?,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountType': accountType.value,
      'status': status,
      if (documentUrl != null) 'documentUrl': documentUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

class VerificationFirestoreDataSource {
  VerificationFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('verificationRequests');

  Future<String> submit({
    required String userId,
    required UserRole accountType,
    String? documentUrl,
  }) async {
    final doc = await _collection.add({
      'userId': userId,
      'accountType': accountType.value,
      'status': 'pending',
      if (documentUrl != null) 'documentUrl': documentUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<VerificationRequestModel?> latestForUser(String userId) async {
    final snap = await _collection.where('userId', isEqualTo: userId).get();
    if (snap.docs.isEmpty) return null;

    final sorted = snap.docs.toList()
      ..sort((a, b) {
        final aDate = a.data()['createdAt'];
        final bDate = b.data()['createdAt'];
        if (aDate is Timestamp && bDate is Timestamp) {
          return bDate.compareTo(aDate);
        }
        return 0;
      });

    final doc = sorted.first;
    return VerificationRequestModel.fromMap(doc.data(), id: doc.id);
  }
}

final verificationDataSourceProvider =
    Provider<VerificationFirestoreDataSource>((ref) {
  return VerificationFirestoreDataSource(ref.watch(firestoreProvider));
});

final selectedVerificationRoleProvider =
    StateProvider<UserRole?>((ref) => null);

final verificationControllerProvider =
    StateNotifierProvider<VerificationController, AsyncValue<void>>((ref) {
  return VerificationController(ref.watch(verificationDataSourceProvider));
});

class VerificationController extends StateNotifier<AsyncValue<void>> {
  VerificationController(this._dataSource) : super(const AsyncData(null));

  final VerificationFirestoreDataSource _dataSource;

  Future<String> submit({
    required String userId,
    required UserRole accountType,
    String? documentUrl,
  }) async {
    state = const AsyncLoading();
    try {
      final id = await _dataSource.submit(
        userId: userId,
        accountType: accountType,
        documentUrl: documentUrl,
      );
      state = const AsyncData(null);
      return id;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
