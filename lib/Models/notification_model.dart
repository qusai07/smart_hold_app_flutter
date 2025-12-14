class NotificationModel {
  final String id;
  final String name;
  final String description;
  final String? notificationType;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.name,
    required this.description,
    this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      notificationType: json['notificationType']?.toString(),
      isRead: json['isRead'] == true || json['isRead'] == 1,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'notificationType': notificationType,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };
}
