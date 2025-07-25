import 'package:dio/Dio.dart';
import 'package:smart_hold_app/Models/Vehicles/Violation.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiConstant.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';

class ViolationService {
  final ApiService apiService;
  final SecureStorage secureStorage;

  ViolationService({required this.apiService, required this.secureStorage});

  Future<List<Violation>> getViolationsForUser(String userId) async {
    try {
      final accessToken = await secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }
      final response = await apiService.get(
        ApiConstants.getViolationsForUser,
        options: Options(headers: _buildHeaders(accessToken)),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Violation.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load violations');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  //   Future<List<Violation>> getActiveMovedVehicles() async {
  //     try {
  //       final response = await dio.get(
  //         '$baseUrl/violations/active-moved-vehicles',
  //       );

  //       if (response.statusCode == 200) {
  //         return (response.data as List)
  //             .map((json) => Violation.fromJson(json))
  //             .toList();
  //       } else {
  //         throw Exception('Failed to load active moved vehicles');
  //       }
  //     } on DioException catch (e) {
  //       throw Exception('Network error: ${e.message}');
  //     }
  //   }
  // }

  Map<String, String> _buildHeaders(String accessToken) {
    return {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };
  }
}
