import 'package:dio/dio.dart';
import 'package:smart_hold_app/Models/api_response.dart';
import 'package:smart_hold_app/Models/notification_model.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_constant.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';

class NotificationsService {
  final ApiService apiService;
  final SecureStorage secureStorage;

  NotificationsService({required this.apiService, required this.secureStorage});

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token == null) throw Exception('No access token available');

      final response = await apiService.get(
        ApiConstants.getNotifications,
        options: Options(headers: _buildHeaders(token)),
      );

      if (response.statusCode == 200) {
        final apiRes = APIResponse.fromJson(Map<String, dynamic>.from(response.data));
        final data = apiRes.data;
        if (data is List) {
          return data.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await secureStorage.clearTokens();
        throw Exception('Unauthorized');
      }
      throw Exception('Failed to load notifications: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load notifications: ${e.toString()}');
    }
  }

  Future<List<NotificationModel>> getUnreadNotifications() async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token == null) throw Exception('No access token available');

      final response = await apiService.get(
        ApiConstants.getUnreadNotifications,
        options: Options(headers: _buildHeaders(token)),
      );

      if (response.statusCode == 200) {
        final apiRes = APIResponse.fromJson(Map<String, dynamic>.from(response.data));
        final data = apiRes.data;
        if (data is List) {
          return data.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load unread notifications: ${e.toString()}');
    }
  }
  
  Future<int> getUnreadCount() async {
    try {
      final all = await getNotifications();
      return all.where((n) => !n.isRead).length;
    } catch (e) {
      throw Exception('Failed to compute unread count: ${e.toString()}');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token == null) throw Exception('No access token available');

      final response = await apiService.post(
        ApiConstants.markAsRead,
        data: {'notificationId': notificationId},
        options: Options(headers: _buildHeaders(token)),
      );

      if (response.statusCode == 200) {
        final resMap = response.data is Map ? Map<String, dynamic>.from(response.data) : {'data': response.data};
        final apiRes = APIResponse.fromJson(resMap);
        return apiRes.message.isNotEmpty;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }
}


Map<String, String> _buildHeaders(String accessToken) {
  return {'Authorization': 'Bearer $accessToken', 'Accept': 'application/json'};
}

