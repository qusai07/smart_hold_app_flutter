import 'package:smart_hold_app/Config/api_config.dart';

class ApiConstants {
  static String get login => ApiConfig.buildPath('Auth/Login');
  static String get signUp => ApiConfig.buildPath('Auth/SignUp');
  static String get logout => ApiConfig.buildPath('Auth/Logout');
  static String get verifyOtp => ApiConfig.buildPath('Auth/SignUpVerifyOtp');

  static String get refreshToken => ApiConfig.buildPath('Auth/RefreshToken');
  static String get getUserProfile => ApiConfig.buildPath('Auth/GetProfile');
  static String get changePassword =>
      ApiConfig.buildPath('Auth/changePassword');
  static String get updateUserProfile =>
      ApiConfig.buildPath('Auth/updateUserProfile');
  static String get uploadProfilePicture =>
      ApiConfig.buildPath('Auth/uploadProfilePicture');

  static String get getMyViolations=> ApiConfig.buildPath('Violations/GetMyViolations');
  static String get getMyViolationsNationalNumber=> ApiConfig.buildPath('Violations/GetMyViolations');

  static String get getMyVehical => ApiConfig.buildPath('Vehicles/GetVehicles');
  static String get getMyVehicalByNationalNumber => ApiConfig.buildPath('Vehicles/GetVehicalByNationalNumber');
  static String get requestHold => ApiConfig.buildPath('Violations/submitHoldRequest');
  static String get checkVehicalHold => ApiConfig.buildPath('Vehicles/checkVehicalHold');

    static String get getUnreadNotifications => ApiConfig.buildPath('Auth/GetUnreadNotifications');
    static String get markAsRead => ApiConfig.buildPath('Auth/MarkAsRead');
    static String get getNotifications => ApiConfig.buildPath('Auth/GetNotifications');

  static String get userProfile => ApiConfig.buildPath('User/Profile');
}
