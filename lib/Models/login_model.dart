class LoginRequest {
  final String usernameOrEmail;
  final String password;

  LoginRequest({required this.usernameOrEmail, required this.password});

  Map<String, dynamic> toJson() {
    return {'UsernameOrEmail': usernameOrEmail, 'Password': password};
  }
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token']
      );
  }
}
