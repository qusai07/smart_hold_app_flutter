import 'package:smart_hold_app/Models/UserProfile.dart';
import 'package:smart_hold_app/Service/Api_Services/Api_service';

class UserService {
  final api = API('http://192.168.1.115:5300');

  static var userName;

  static var isActive;

  static var id;
  static Future<UserProfile?> fetchUserProfile(String token) async {
    return null;
  }
}
