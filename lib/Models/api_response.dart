import 'package:smart_hold_app/Models/signup_model.dart';

class APIResponse {
  final bool success;
  final String message;
  final dynamic data;

  APIResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    final dataField = json['data'];

    if (dataField is Map<String, dynamic> &&
        dataField.containsKey('id') &&
        dataField.containsKey('otpCode')) {
      return APIResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: SignUpResponse.fromJson(dataField),
      );
    }

    return APIResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataField,
    );
  }
}
