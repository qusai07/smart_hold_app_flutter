import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const storage = FlutterSecureStorage();
  static const tokenKey = 'auth_token';
  static const refreshTokenKey = 'refresh_token';

  // حفظ التوكن
  static Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  // استرجاع التوكن
  static Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  // حذف التوكن (عند تسجيل الخروج)
  static Future<void> deleteToken() async {
    await storage.delete(key: tokenKey);
  }

  // التحقق من وجود توكن
  static Future<bool> hasToken() async {
    return await storage.containsKey(key: tokenKey);
  }
}
