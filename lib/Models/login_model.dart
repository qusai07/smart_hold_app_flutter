class LoginRequest {
  final String userName;
  final String password;

  LoginRequest({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    return {'UserName': userName, 'Password': password};
  }
}

class LoginResponse {
  final String token;
  final String? message;

  LoginResponse({required this.token, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token'] ?? '', message: json['message']);
  }
}
