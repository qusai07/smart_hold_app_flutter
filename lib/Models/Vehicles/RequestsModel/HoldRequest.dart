import 'package:smart_hold_app/Models/Vehicles/ResponseModel/VehicalResponse.dart';

class HoldRequest {
  final String id;
  final String plateNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final DateTime requestDate;
  final bool isStart;
  final String vehicleId;
  final VehicleResponse? vehicle;
  HoldRequest({
    required this.id,
    required this.plateNumber,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.requestDate,
    required this.isStart,
    required this.vehicleId,
    this.vehicle,
  });

  factory HoldRequest.fromJson(Map<String, dynamic> json) {
    return HoldRequest(
      id: json['id'],
      plateNumber: json['plateNumber'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      requestDate: DateTime.parse(json['requestDate']),
      isStart: json['isStart'],
      vehicleId: json['vehicleId'],
      vehicle: json['vehicle'] != null
          ? VehicleResponse.fromJson(json['vehicle'])
          : null,
    );
  }
}
