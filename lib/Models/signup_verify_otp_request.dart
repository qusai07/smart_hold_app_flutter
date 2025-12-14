class SignupVerifyOtpRequest {
  final String id;
  final String otpCode;

  SignupVerifyOtpRequest({
    required this.id,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'otpCode': otpCode,
      };
}
