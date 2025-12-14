import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hold_app/Models/notification_model.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';
import 'package:smart_hold_app/Services/BackEndService/notifications_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsService _service;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = NotificationsService(
      apiService: ApiService(),
      secureStorage: SecureStorage(),
    );
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await _service.getNotifications();
      setState(() => _notifications = items);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(int index) async {
    final n = _notifications[index];
    try {
      final success = await _service.markAsRead(n.id);
      if (success) {
        setState(() {
          _notifications[index].isRead = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: ${e.toString()}')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final topPadding =
      MediaQuery.of(context).padding.top + kToolbarHeight;

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Notifications',
        style: TextStyle(color: Colors.white),
      ),
    ),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding + 12),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : _notifications.isEmpty
                    ? const Center(
                        child: Text(
                          'No notifications',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        color: Colors.white,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          itemCount: _notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final n = _notifications[index];
                            return _buildNotificationItem(n, index);
                          },
                        ),
                      ),
      ),
    ),
  );
}
Widget _buildNotificationItem(NotificationModel n, int index) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white24),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        n.isRead
            ? Icons.notifications_none
            : Icons.notifications_active,
        color:
            n.isRead ? Colors.white54 : Colors.tealAccent[400],
        size: 28,
      ),
      title: Text(
        n.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              n.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('yyyy-MM-dd HH:mm')
                  .format(n.createdAt.toLocal()),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (!n.isRead) {
          await _markAsRead(index);
        }
      },
    ),
  );
}



}
