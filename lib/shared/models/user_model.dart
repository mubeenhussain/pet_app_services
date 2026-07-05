import 'package:equatable/equatable.dart';
import 'package:pet_app/shared/enums/user_role.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.username,
    required this.phone,
    required this.role,
    this.email,
    this.city,
    this.avatarUrl,
    this.verified = false,
    this.suspended = false,
    this.roles = const [],
    this.createdAt,
  });

  final String uid;
  final String username;
  final String phone;
  final UserRole role;
  final String? email;
  final String? city;
  final String? avatarUrl;
  final bool verified;
  final bool suspended;
  final List<UserRole> roles;
  final DateTime? createdAt;

  bool get isAdmin => role == UserRole.admin || roles.contains(UserRole.admin);

  factory UserModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    final roleValue = map['role'] as String? ?? UserRole.petOwner.value;
    final rolesList = (map['roles'] as List<dynamic>?)
            ?.map((e) => UserRole.fromValue(e as String))
            .toList() ??
        [];

    return UserModel(
      uid: uid,
      username: map['username'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: UserRole.fromValue(roleValue),
      email: map['email'] as String?,
      city: map['city'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      verified: map['verified'] as bool? ?? false,
      suspended: map['suspended'] as bool? ?? false,
      roles: rolesList,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'phone': phone,
      'role': role.value,
      'email': email,
      'city': city,
      'avatarUrl': avatarUrl,
      'verified': verified,
      'suspended': suspended,
      'roles': roles.map((r) => r.value).toList(),
    };
  }

  UserModel copyWith({
    String? username,
    String? phone,
    UserRole? role,
    String? email,
    String? city,
    String? avatarUrl,
    bool? verified,
    bool? suspended,
    List<UserRole>? roles,
  }) {
    return UserModel(
      uid: uid,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      email: email ?? this.email,
      city: city ?? this.city,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      verified: verified ?? this.verified,
      suspended: suspended ?? this.suspended,
      roles: roles ?? this.roles,
      createdAt: createdAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props => [uid, username, phone, role, verified];
}
