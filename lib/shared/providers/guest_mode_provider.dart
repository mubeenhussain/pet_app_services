import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory guest flag; persisted via [LocalStorageService] on app start.
final guestModeProvider = StateProvider<bool>((ref) => false);
