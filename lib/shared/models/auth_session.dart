import 'package:equatable/equatable.dart';
import 'package:pet_app/shared/models/user_model.dart';

class AuthSession extends Equatable {
  const AuthSession({
    this.user,
    this.isGuest = false,
  });

  final UserModel? user;
  final bool isGuest;

  bool get isAuthenticated => user != null && !isGuest;

  static const guest = AuthSession(isGuest: true);
  static const unauthenticated = AuthSession();

  @override
  List<Object?> get props => [user, isGuest];
}
