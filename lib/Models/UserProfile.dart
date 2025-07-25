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
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'emailAddress': emailAddress,
      'isActive': isActive,
    };
  }
}
