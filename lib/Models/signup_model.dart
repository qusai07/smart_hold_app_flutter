
class SignUpRequest {
  final String fullName;
  final String userName;
  final String mobileNumber;
  final String emailAddress;
  final String nationalNumber;
  final String password;
  final int userRole;

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
  final String Id;
  final String otpCode;

  SignUpResponse({
    required this.Id,
    required this.otpCode,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      otpCode: json['otpCode'],
      Id: json['id'],
    );
  }
}
