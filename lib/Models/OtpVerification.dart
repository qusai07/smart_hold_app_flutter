class SignupResendOtpRequest {
  final String id;

  SignupResendOtpRequest({required this.id});

  Map<String, dynamic> toJson() => {'Id': id};
}

class SignupVerifyOtpRequest {
  final String id;
  final String otpCode;

  SignupVerifyOtpRequest({required this.id, required this.otpCode});

  Map<String, dynamic> toJson() => {'Id': id, 'OtpCode': otpCode};
}
