import 'package:smart_hold_app/Config/ApiConfig.dart';

class ApiConstants {
  static String get login => ApiConfig.buildPath('Auth/Login');
  static String get signUp => ApiConfig.buildPath('Auth/SignUp');
  static String get refreshToken => ApiConfig.buildPath('Auth/RefreshToken');
  static String get getUserProfile => ApiConfig.buildPath('Auth/GetProfile');
  static String get changePassword =>
      ApiConfig.buildPath('Auth/changePassword');
  static String get updateUserProfile =>
      ApiConfig.buildPath('Auth/updateUserProfile');
  static String get uploadProfilePicture =>
      ApiConfig.buildPath('Auth/uploadProfilePicture');

  // مثال لنقاط نهاية أخرى
  static String get userProfile => ApiConfig.buildPath('User/Profile');
}
