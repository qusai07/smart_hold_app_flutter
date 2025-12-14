
class ViolationRequestModel {
  final String plateNumber;
  ViolationRequestModel({required this.plateNumber});

  Map<String, dynamic> toJson() {
    return {'plateNumber': plateNumber};
  }
}
