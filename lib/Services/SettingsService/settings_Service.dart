import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';

class SettingsService {
  final SecureStorage secureStorage;

  SettingsService({required this.secureStorage});

  static const _languageKey = 'language';
  static const _notificationsKey = 'notifications';

  Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ar';
  }

  Future<void> setNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

}
