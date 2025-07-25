import 'package:smart_hold_app/Models/Vehicles/RequestsModel/HoldRequest.dart';

class Violation {
  final String id;
  final String holdRequestId;
  final HoldRequest holdRequest;
  final String description;
  final DateTime violationDate;
  final bool isResolved;

  Violation({
    required this.id,
    required this.holdRequestId,
    required this.holdRequest,
    required this.description,
    required this.violationDate,
    required this.isResolved,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    return Violation(
      id: json['id'],
      holdRequestId: json['holdRequestId'],
      holdRequest: HoldRequest.fromJson(json['holdRequest']),
      description: json['description'],
      violationDate: DateTime.parse(json['violationDate']),
      isResolved: json['isResolved'],
    );
  }
}
