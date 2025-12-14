import 'package:intl/intl.dart';

class HoldRequest {
  final String vehicleId;
  final DateTime startDate;
  final String location;

  HoldRequest({
    required this.vehicleId,
    required this.startDate,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'VehicleId': vehicleId,
      'StartDate': "${DateFormat('yyyy-MM-dd').format(startDate)}T00:00:00",
      'Location': location,
    };
  }

  factory HoldRequest.fromJson(Map<String, dynamic> json) {
    return HoldRequest(
      vehicleId: json['VehicleId'],
      startDate: DateTime.parse(json['StartDate']),
      location: json['Location'],
    );
  }
}
