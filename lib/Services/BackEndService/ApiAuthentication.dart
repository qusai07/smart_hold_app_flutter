import 'package:dio/dio.dart';
import 'package:smart_hold_app/Models/login_model.dart';
import 'package:smart_hold_app/Models/signup_model.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Security/TokenManager.dart';
// import 'package:smart_hold_app/Models/signup_model.dart';
// import 'package:smart_hold_app/Security/SecureStorage.dart';
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

  /// Handles user registration and returns [SignUpResponse]
  /// Throws [ApiException] on failure
  Future<SignUpResponse> signUp(SignUpRequest request) async {
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

      // Validate successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return SignUpResponse.fromJson(response.data);
        } catch (e) {
          throw ApiException(
            message: 'Failed to parse server response',
            statusCode: response.statusCode,
          );
        }
      }

      // Handle error responses
      throw ApiException(
        message: _extractErrorMessage(response.data) ?? 'Registration failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ApiException(
        message: _extractErrorMessage(e.response?.data) ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error occurred',
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

//   Future<Response> logout({required String refreshToken}) async {
//     String url = AuthEndpoints.userLogout;
//     final Map<String, dynamic> header = makeHeaders(refreshToken, true);
//     Response response = await api.post(url, headers: header);
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
