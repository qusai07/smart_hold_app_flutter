import 'package:dio/dio.dart';
import 'package:smart_hold_app/Models/APIResponse.dart';
import 'package:smart_hold_app/Models/OtpVerification.dart';
import 'package:smart_hold_app/Models/signup_model.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Security/TokenManager.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiConstant.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';

class ApiAuthentication {
  final ApiService apiService;
  final SecureStorage secureStorage;

  ApiAuthentication({required this.apiService, required this.secureStorage});

  Future<Response> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.login,
        data: {'userNameOrEmail': usernameOrEmail, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data == null || response.data.toString().isEmpty) {
        throw Exception('Token not received from server');
      }
      await TokenManager.saveToken(response.data);
      await secureStorage.saveTokens(
        accessToken: response.data,
        refreshToken: response.data,
      );

      return response;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<APIResponse> signUp(SignUpRequest request) async {
    try {
      final response = await apiService.post(
        ApiConstants.signUp,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        if (res == null) {
          throw ApiException(
            message: 'Empty or invalid response from server',
            statusCode: response.statusCode,
          );
        }
        return APIResponse.fromJson(res);
      }

      throw ApiException(
        message: (response.data is Map<String, dynamic>)
            ? response.data['message'] ?? 'Registration failed'
            : 'Registration failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }

  /// Extracts error message from API response
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message']?.toString() ??
          responseData['error']?.toString();
    }
    return null;
  }

  Future<Response> logout({required String refreshToken}) async {
    try {
      final response = await apiService.post(
        ApiConstants.logout,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'refresher-token': refreshToken,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        try {} catch (_) {}
        try {
          await secureStorage.clearTokens();
        } catch (_) {}
      }

      return response;
    } on DioException catch (e) {
      throw ApiException(
        message:
            _extractErrorMessage(e.response?.data) ?? 'Network error on logout',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Logout failed: ${e.toString()}');
    }
  }

  Future<APIResponse> verifyOtp(SignupVerifyOtpRequest request) async {
    try {
      final response = await apiService.post(
        ApiConstants.verifyOtp,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse.fromJson(response.data);
      }

      throw ApiException(
        message: response.data?['message'] ?? 'OTP verification failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: null,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final DateTime timestamp = DateTime.now();

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    return statusCode != null ? '[$statusCode] $message' : message;
  }
}

//   // Future<Map<String, dynamic>> getConfig() async {
//   //   try {
//   //     final response = await fetchConfig();
//   //     if (response?.statusCode == 200) {
//   //       final data = response?.data as Map<String, dynamic>;
//   //       return data;
//   //     } else {
//   //       return {'ipAdress': '34.30.38.82', 'version': '1.0.0', 'url': ''};
//   //     }
//   //   } catch (e) {
//   //     logError(e.toString());
//   //     return {'ipAdress': '34.30.38.82', 'version': '1.0.0', 'url': ''};
//   //   }
//   // }

//   Future<Response> UserSignIn({
//     required String email,
//     required String password,
//   }) async {
//     String url = AuthEndpoints.UserLogin;

//     final Map<String, dynamic> body = makeBody(email, password);

//     try {
//       Response response = await api.post(url, body: body);
//       return response;
//     } on Exception {
//       rethrow;
//     }
//   }

//   Future<Response?> checkServer() async {
//     String url = ApiConstants.baseUrlWithPort;
//     Response? response = await api.get(url);
//     return response;
//   }

//   Future<Response> refreshToken({required String refreshToken}) async {
//     String url = AuthEndpoints.refreshToken;
//     final Map<String, dynamic> header = makeHeaders(refreshToken, true);
//     Response response = await api.post(url, headers: header);
//     return response;
//   }

//   // Future<Response> editPassword({
//   //   required String oldPassword,
//   //   required String newPassword,
//   //   required String token,
//   // }) async {
//   //   String url = UserEndpoints.editPassword;
//   //   final Map<String, dynamic> header = {'Authorization': 'Bearer $token'};
//   //   final Map<String, dynamic> body = {
//   //     "oldPassword": oldPassword,
//   //     "newPassword": newPassword,
//   //   };
//   //   Response response = await api.put(url, headers: header, body: body);
//   //   return response;
//   // }

//   Map<String, String> makeHeaders(String value, bool isToken) {
//     if (isToken) {
//       return {"refresher-token": value};
//     }
//     return {'device-id': value};
//   }

//   Map<String, dynamic> makeBody(String email, String password) {
//     return {"userEmail": email, "password": password};
//   }

//   void logError(String string) {
//     print('AuthApi Error: $string');
//   }
// }
