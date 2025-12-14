import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/vehical_request.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/vehical_response.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_constant.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';
import 'package:smart_hold_app/Models/user_profile.dart';

class Userservices {
  final ApiService apiService;
  final SecureStorage secureStorage;

  Userservices({required this.apiService, required this.secureStorage});

  Future<UserProfile> fetchUserProfile() async {
    try {
      final accessToken = await secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await apiService.get(
        ApiConstants.getUserProfile,
        options: Options(headers: _buildHeaders(accessToken)),
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await secureStorage.clearTokens();
        throw UnauthorizedException('Session expired. Please login again.');
      }
      throw Exception('Failed to load profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load profile: ${e.toString()}');
    }
  }

  Future<List<VehicleResponse>> getMyVehicles(VehicalRequest request) async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token == null) throw Exception('No access token available');

      final response = await apiService.post(
        ApiConstants.getMyVehical,
        data: request.toJson(),
        options: Options(headers: _buildHeaders(token)),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (request.isInfo &&
            responseData != null &&
            responseData['message'] == 'VehiclesFoundInFileAndRegistered') {
          return await getMyVehicles(VehicalRequest(
            nationalNumber: request.nationalNumber,
            isInfo: false,
          ));
        }

        final data = responseData != null ? responseData['data'] : null;
        if (data != null) {
          List<VehicleResponse> vehicles = (data as List)
              .map((json) => VehicleResponse.fromJson(json))
              .toList();
          await saveVehiclesToStorage(vehicles);
          return vehicles;
        }

        final savedVehicles = await getSavedVehicles();
        if (savedVehicles.isNotEmpty) return savedVehicles;

        final serverMessage = responseData != null ? responseData['message'] : null;
        throw Exception(serverMessage ?? 'No vehicles found');
      } else {
        throw Exception('Failed to load Vehicle: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await secureStorage.clearTokens();
        throw UnauthorizedException('Session expired. Please login again.');
      }
      throw Exception('Failed to load Vehicle: ${e.message}');
    } catch (e) {
      final savedVehicles = await getSavedVehicles();
      if (savedVehicles.isNotEmpty) return savedVehicles;
      throw Exception('Failed to load vehicles: $e');
    }
  }

  Future<void> saveVehiclesToStorage(List<VehicleResponse> vehicles) async {
    final vehiclesJson = vehicles.map((v) => v.toJson()).toList();
    await secureStorage.write(
      key: 'user_vehicles',
      value: jsonEncode(vehiclesJson),
    );
  }

  Future<List<VehicleResponse>> getSavedVehicles() async {
    final vehiclesJson = await secureStorage.read(key: 'user_vehicles');
    if (vehiclesJson == null) return [];

    final List<dynamic> jsonList = jsonDecode(vehiclesJson);
    return jsonList.map((json) => VehicleResponse.fromJson(json)).toList();
  }
}

Map<String, String> _buildHeaders(String accessToken) {
  return {'Authorization': 'Bearer $accessToken', 'Accept': 'application/json'};
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}
