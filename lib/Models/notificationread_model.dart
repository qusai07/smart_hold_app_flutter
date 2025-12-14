class NotificationReadModel {
  final String Notificationid;

  NotificationReadModel({required this.Notificationid});

  factory NotificationReadModel.fromJson(Map<String, dynamic> json) {
    return NotificationReadModel(Notificationid: json['id']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'id': Notificationid};
}
