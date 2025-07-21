import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_hold_app/Models/Token.dart';
import 'package:smart_hold_app/Security/Secure_Storage.dart';
import 'package:smart_hold_app/Service/Api_Services/Api_Authentication.dart';
import 'package:smart_hold_app/main.dart';

class APIInspector {
  final Dio dio;

  APIInspector(this.dio);

  bool _isRefreshing = false;

  Options createOptions({
    Map<String, dynamic>? headers,
    bool isJson = true,
    bool isToken = true,
    String? token,
    bool isMultipart = false,
    Duration? receiveTimeout = const Duration(seconds: 30),
    Duration? sendTimeout = const Duration(seconds: 30),
  }) {
    headers = headers ?? {};
    if (isToken && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return Options(
      headers: headers,
      responseType: isJson ? ResponseType.json : ResponseType.bytes,
      contentType: isMultipart ? "multipart/form-data" : "application/json",
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
  }

  /// Handles a [DioException] by attempting to refresh the access token
  /// when the status code is 401 and retrying the original request with
  /// the new access token. If the refresh token is expired or failed,
  /// it signs out the user and navigates to the login screen.
  Future<Response?> handleError(
    DioException e,
    RequestOptions requestOptions,
  ) async {
    if (e.response?.statusCode == 401 &&
        !_isRefreshing &&
        await SecureStorageApi.instance.isUserLoggedIn()) {
      _isRefreshing = true;
      try {
        final refresherToken = await SecureStorageApi.instance
            .getRefreshToken();
        final refreshedToken = await getIt<AuthService>().refreshToken(
          refreshToken: refresherToken!,
        );

        if (refreshedToken is AccessTokenModel) {
          final newOptions = createOptions(
            headers: {
              ...requestOptions.headers,
              "Authorization":
                  "Bearer ${await SecureStorageApi.instance.getAccessToken()}",
            },
          );

          if (requestOptions.data is FormData) {
            final formData = requestOptions.data as FormData;
            return await dio.request(
              requestOptions.path,
              options: newOptions,
              data: formData,
              queryParameters: requestOptions.queryParameters,
            );
          } else {
            return await dio.request(
              requestOptions.path,
              options: newOptions,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
          }
        }
      } on DioException catch (e) {
        await _handleTokenExpiration(e);
      } finally {
        _isRefreshing = false;
      }
    }
    return e.response;
  }

  /// Handles token expiration by clearing session data, redirecting the user
  /// to the sign-in page, and displaying a session expiration message.
  Future<void> _handleTokenExpiration(DioException e) async {
    try {
      if (e.response?.statusCode == 401) {
        await SecureStorageApi.instance.logout();
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RoleDesesion()),
            (Route<dynamic> route) => false,
          );
        }
        final overlayState = navigatorKey.currentState?.overlay;
        if (overlayState != null) {
          final message = 'Session expired, Please login again';
          final icon = Icons.warning;
          final color = const Color.fromARGB(255, 231, 200, 0);
          customSnackbar(overlayState, message, icon, color);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
