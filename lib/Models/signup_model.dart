// Models/signup_model.dart

class SignUpRequest {
  final String userName;
  final String email;
  final String nationalId;
  final String password;

  SignUpRequest({
    required this.userName,
    required this.email,
    required this.nationalId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'email': email,
    'nationalId': nationalId,
    'password': password,
  };
}

class SignUpResponse {
  final bool success;
  final String? message;

  SignUpResponse({required this.success, this.message});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
