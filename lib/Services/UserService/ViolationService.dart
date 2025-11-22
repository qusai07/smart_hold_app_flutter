
import 'package:dio/Dio.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/HoldRequest.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/ViolationResponseAfterIntegration.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/ViolationResponsebeforeIntegration.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiConstant.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';

class ViolationService {
  final ApiService apiService;
  final SecureStorage secureStorage;

  ViolationService({required this.apiService, required this.secureStorage});
  
 Future<void> requestHold(HoldRequest request) async {
  try {
    final accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token available');
    }

    final response = await apiService.post(
      ApiConstants.requestHold,
      data: request.toJson(), 
      options: Options(headers: _buildHeaders(accessToken)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit hold request: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Failed to submit hold request: $e');
  }
}


  Future<List<ViolationResponseAfterIntegration>> getMyViolations() async {
    try {
      final accessToken = await secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await apiService.get(
        ApiConstants.getMyViolations,
        options: Options(headers: _buildHeaders(accessToken)),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map && responseData.containsKey('message')) {
          final message = responseData['message'];
          final data = responseData['data'];

          if (message == 'NoViolationOnVehicle') {
            return [];
          }
          if (message == 'VehiclesViolationsFound') {
            if (data is List) {
              return data
                  .map(
                    (json) => ViolationResponseAfterIntegration.fromJson(
                      Map<String, dynamic>.from(json),
                    ),
                  )
                  .toList();
            } else if (data is Map) {
              // API returned a single object
              return [
                ViolationResponseAfterIntegration.fromJson(
                  Map<String, dynamic>.from(data),
                ),
              ];
            }
          }

          throw Exception('Unexpected message or data format: $message');
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load violations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch violations: $e');
    }
  }

  Future<List<ViolationResponseBeforeIntegration>>
  getMyViolationsByNationalNumber(String plateNumber, bool isInfo) async {
    try {
      final accessToken = await secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }
      final requestBody = {'plateNumber': plateNumber, 'isInfo': isInfo};
      final response = await apiService.post(
        ApiConstants.getMyViolationsNationalNumber,
        data: requestBody,
        options: Options(headers: _buildHeaders(accessToken)),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == 'VehiclesViolationsFound') {
          final data = responseData['data'];
          if (data != null) {
            if (data is List) {
              return data
                  .map(
                    (json) => ViolationResponseBeforeIntegration.fromJson(
                      Map<String, dynamic>.from(json),
                    ),
                  )
                  .toList();
            } else if (data is Map) {
              return [
                ViolationResponseBeforeIntegration.fromJson(
                  Map<String, dynamic>.from(data),
                ),
              ];
            }
          }
          return [];
        } else {
          throw Exception('Server returned: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load violations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await secureStorage.clearTokens();
        throw Exception('Unauthorized: Please log in again.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch violations: $e');
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
