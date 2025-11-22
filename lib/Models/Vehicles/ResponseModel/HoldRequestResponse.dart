class HoldRequestResponse {
  final String id;
  final String plateNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final DateTime requestDate;
  final bool isStart;

  HoldRequestResponse({
    required this.id,
    required this.plateNumber,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.requestDate,
    required this.isStart,
  });

  factory HoldRequestResponse.fromJson(Map<String, dynamic> json) {
    return HoldRequestResponse(
      id: json['id'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'] ?? '',
      requestDate: DateTime.parse(json['requestDate']),
      isStart: json['isStart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'requestDate': requestDate.toIso8601String(),
      'isStart': isStart,
    };
  }
}
