enum UserRole {
  petOwner('pet_owner'),
  seller('seller'),
  provider('provider'),
  houser('houser'),
  clinic('clinic'),
  admin('admin');

  const UserRole(this.value);

  final String value;

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.petOwner,
    );
  }

  bool get needsVerification =>
      this == UserRole.seller ||
      this == UserRole.provider ||
      this == UserRole.houser ||
      this == UserRole.clinic;
}
