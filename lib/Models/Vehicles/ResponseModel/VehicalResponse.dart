class VehicleResponse {
  final String id;
  final String plateNumber;
  final String model;
  final String type;
  final String color;
  final String ownerNationalNumber;
  final String ownerUserId;
  final DateTime registrationDate;

  VehicleResponse({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.type,
    required this.color,
    required this.ownerNationalNumber,
    required this.ownerUserId,
    required this.registrationDate,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      id: json['id'],
      plateNumber: json['plateNumber'],
      model: json['model'],
      type: json['type'],
      color: json['color'],
      ownerNationalNumber: json['ownerNationalNumber'],
      ownerUserId: json['ownerUserId'],
      registrationDate: DateTime.parse(json['registrationDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'model': model,
      'type': type,
      'color': color,
      'ownerNationalNumber': ownerNationalNumber,
      'ownerUserId': ownerUserId,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
}
