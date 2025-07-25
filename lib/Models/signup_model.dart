// Models/signup_model.dart

class SignUpRequest {
  final String fullName;
  final String userName;
  final String mobileNumber;
  final String emailAddress;
  final String nationalNumber;
  final String password;
  final bool userRole;

  SignUpRequest({
    required this.fullName,
    required this.userName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.nationalNumber,
    required this.password,
    required this.userRole,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "userName": userName,
    "mobileNumber": mobileNumber,
    "emailAddress": emailAddress,
    "nationalNumber": nationalNumber,
    "password": password,
    "userRole": userRole,
  };
}

class SignUpResponse {
  final bool success;
  final String OtpCode;
  final String message;

  SignUpResponse({
    required this.success,
    required this.OtpCode,
    required this.message,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      OtpCode: json['OtpCode'],
      message: json['message'],
    );
  }
}
