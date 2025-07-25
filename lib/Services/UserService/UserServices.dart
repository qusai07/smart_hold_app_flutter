import 'package:dio/dio.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiConstant.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';
import 'package:smart_hold_app/Models/UserProfile.dart';

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

  /// Updates user profile information
  // Future<UserProfile> updateUserProfile(UserProfile updatedProfile) async {
  //   try {
  //     final accessToken = await secureStorage.getAccessToken();
  //     if (accessToken == null) {
  //       throw Exception('No access token available');
  //     }

  //     final response = await apiService.post(
  //       ApiConstants.updateUserProfile,
  //       data: updatedProfile.toJson(),
  //       options: Options(
  //         headers: _buildHeaders(accessToken),
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return UserProfile.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to update profile: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to update profile: ${e.message}');
  //   }
  // }

  // /// Changes user password
  // Future<void> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     final accessToken = await secureStorage.getAccessToken();
  //     if (accessToken == null) {
  //       throw Exception('No access token available');
  //     }

  //     final response = await apiService.post(
  //       ApiConstants.changePassword,
  //       data: {
  //         'currentPassword': currentPassword,
  //         'newPassword': newPassword,
  //       },
  //       options: Options(
  //         headers: _buildHeaders(accessToken),
  //       ),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to change password: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to change password: ${e.message}');
  //   }
  // }

  // /// Uploads user profile picture
  // Future<String> uploadProfilePicture(String imagePath) async {
  //   try {
  //     final accessToken = await secureStorage.getAccessToken();
  //     if (accessToken == null) {
  //       throw Exception('No access token available');
  //     }

  //     final formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(imagePath),
  //     });

  //     final response = await apiService.post(
  //       ApiConstants.uploadProfilePicture,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           ..._buildHeaders(accessToken),
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data['imageUrl'];
  //     } else {
  //       throw Exception('Failed to upload picture: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to upload picture: ${e.message}');
  //   }
  // }

  Map<String, String> _buildHeaders(String accessToken) {
    return {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}
