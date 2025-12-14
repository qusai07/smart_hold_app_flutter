import 'package:smart_hold_app/Models/Vehicles/ResponseModel/hold_request_response.dart';

class ViolationResponseAfterIntegration {
  final String id;
  final String vehicleId;
  final String? holdRequestId;
  final HoldRequestResponse? holdRequest;
  final String description;
  final DateTime violationDate;
  final bool isResolved;
  final int holdDuration;
  final String? plateNumber;

  ViolationResponseAfterIntegration({
    required this.id,
    required this.vehicleId,
    this.holdRequestId,
    this.holdRequest,
    required this.description,
    required this.violationDate,
    required this.isResolved,
    required this.holdDuration,
    this.plateNumber,
  });

  factory ViolationResponseAfterIntegration.fromJson(Map<String, dynamic> json) {
    final vehicleJson = json['vehicle'] as Map<String, dynamic>?;
    final holdJson = json['holdRequest'] as Map<String, dynamic>?;

    return ViolationResponseAfterIntegration(
      id: json['id'] ?? '',
      vehicleId: vehicleJson?['vehicleId'] ?? '',
      plateNumber: vehicleJson?['plateNumber'],
      holdRequestId: holdJson?['id'],
      holdRequest: holdJson != null ? HoldRequestResponse.fromJson(holdJson) : null,
      description: json['description'] ?? '',
      violationDate: DateTime.parse(json['violationDate']),
      isResolved: json['isResolved'] ?? false,
      holdDuration: json['holdDuration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'violationDate': violationDate.toIso8601String(),
      'isResolved': isResolved,
      'holdDuration': holdDuration,
      'vehicle': {
        'vehicleId': vehicleId,
        'plateNumber': plateNumber,
      },
      'holdRequest': holdRequest?.toJson(),
    };
  }
}
