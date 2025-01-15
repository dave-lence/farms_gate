class UserProfile {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? avatar;

  UserProfile({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.avatar,
  });

  // Factory method to create an instance from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?, // Nullable field
    );
  }
}
