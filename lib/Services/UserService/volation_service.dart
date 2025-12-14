import 'package:dio/dio.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/hold_request.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/viloation_request_model.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/violation_response_after_integration.dart';
import 'package:smart_hold_app/Models/violations_api_response.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/violation_response_before_integration.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_constant.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';

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
        throw Exception(
          'Failed to submit hold request: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to submit hold request: $e');
    }
  }

  Future<ViolationsApiResponse> getMyViolations(ViolationRequestModel model) async {
    try {
      final accessToken = await secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }
    
      final endpoint = ApiConstants.getMyViolations;
      final response = await apiService.post(
        endpoint,
        data: {"plateNumber": model.plateNumber},
        options: Options(headers: _buildHeaders(accessToken)),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map && responseData.containsKey('message')) {
          return ViolationsApiResponse.fromJson(Map<String, dynamic>.from(responseData));
        }
        throw Exception('Invalid response structure');
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

  Map<String, String> _buildHeaders(String accessToken) {
    return {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };
  }
}
