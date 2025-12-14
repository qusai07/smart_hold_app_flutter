import 'package:smart_hold_app/Models/Vehicles/ResponseModel/violation_response_after_integration.dart';

class ViolationsApiResponse {
  final String message;
  final List<ViolationResponseAfterIntegration> violations;

  ViolationsApiResponse({required this.message, required this.violations});

  factory ViolationsApiResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message']?.toString() ?? '';
    final data = json['data'];
    List<ViolationResponseAfterIntegration> list = [];

    if (data != null) {
      if (data is List) {
        list = data
            .map((e) => ViolationResponseAfterIntegration.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (data is Map) {
        list = [ViolationResponseAfterIntegration.fromJson(Map<String, dynamic>.from(data))];
      }
    }

    return ViolationsApiResponse(message: message, violations: list);
  }
}
