class UserProfile {
  final String id;
  final String fullName;
  final String userName;
  final String emailAddress;
  final bool isActive;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.emailAddress,
    required this.isActive,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['ID'] as String,
      fullName: json['FullName'] as String,
      userName: json['UserName'] as String,
      emailAddress: json['EmailAddress'] as String,
      isActive: json['IsActive'] as bool,
    );
  }

  toJson() {}
}
