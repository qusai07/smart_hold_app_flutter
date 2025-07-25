class VehicalRequest {
  final String nationalNumber;
  final bool isInfo;
  VehicalRequest({required this.nationalNumber, required this.isInfo});

  Map<String, dynamic> toJson() {
    return {'nationalNumber': nationalNumber, 'isInfo': isInfo};
  }
}
