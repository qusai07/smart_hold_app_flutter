class ViolationResponseBeforeIntegration {
  final String id;
  final DateTime requestDate;
  final bool isStart;
  final int holdDuration;

  ViolationResponseBeforeIntegration({
    required this.id,
    required this.requestDate,
    required this.isStart,
    required this.holdDuration,
  });

  factory ViolationResponseBeforeIntegration.fromJson(Map<String, dynamic> json) {
    return ViolationResponseBeforeIntegration(
      id: json['id'] ?? '',
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : DateTime.now(),
      isStart: json['isStart'] ?? false,
      holdDuration: json['holdDuration'] ?? 0,
    );
  }
}
