import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('👉 Request: ${options.method} ${options.uri}');
    print('📦 Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ Response: ${response.statusCode}');
    print('📦 Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ Error: ${err.message}');
    print('⚠️ Status: ${err.response?.statusCode}');
    super.onError(err, handler);
  }
}

// class APIInspector extends Interceptor {
//   final Dio dio;
//   AuthApi? authApi;
//   APIInspector(this.dio);

//   void setAuthApi(AuthApi authApi) {
//     authApi = authApi;
//   }

//   bool _isRefreshing = false;

//   Options createOptions({
//     Map<String, dynamic>? headers,
//     bool isJson = true,
//     bool isToken = true,
//     String? token,
//     bool isMultipart = false,
//     Duration? receiveTimeout = const Duration(seconds: 30),
//     Duration? sendTimeout = const Duration(seconds: 30),
//   }) {
//     headers = headers ?? {};
//     if (isToken && token != null && token.isNotEmpty) {
//       headers['Authorization'] = 'Bearer $token';
//     }

//     return Options(
//       headers: headers,
//       responseType: isJson ? ResponseType.json : ResponseType.bytes,
//       contentType: isMultipart ? "multipart/form-data" : "application/json",
//       receiveTimeout: receiveTimeout,
//       sendTimeout: sendTimeout,
//     );
//   }

//   Future<Response?> handleError(
//     DioException e,
//     RequestOptions requestOptions,
//   ) async {
//     if (e.response?.statusCode == 401 &&
//         !_isRefreshing &&
//         await SecureStorageApi.instance.isUserLoggedIn()) {
//       _isRefreshing = true;
//       try {
//         final refresherToken = await SecureStorageApi.instance
//             .getRefreshToken();
//         final refreshedToken = await authApi!.refreshToken(
//           refreshToken: refresherToken!,
//         );

//         if (refreshedToken is AccessTokenModel) {
//           await SecureStorageApi.instance.setAccessToken(
//             refreshedToken.accessToken,
//           );

//           final newOptions = createOptions(
//             headers: {
//               ...requestOptions.headers,
//               "Authorization": "Bearer ${refreshedToken.accessToken}",
//             },
//           );

//           if (requestOptions.data is FormData) {
//             return await dio.request(
//               requestOptions.path,
//               options: newOptions,
//               data: requestOptions.data,
//               queryParameters: requestOptions.queryParameters,
//             );
//           } else {
//             return await dio.request(
//               requestOptions.path,
//               options: newOptions,
//               data: requestOptions.data,
//               queryParameters: requestOptions.queryParameters,
//             );
//           }
//         }
//       } on DioException catch (e) {
//         await _handleTokenExpiration(e);
//       } finally {
//         _isRefreshing = false;
//       }
//     }
//     return e.response;
//   }

//   Future<void> _handleTokenExpiration(DioException e) async {
//     try {
//       if (e.response?.statusCode == 401) {
//         await SecureStorageApi.instance.logout();
//         if (navigatorKey.currentState?.canPop() == true) {
//           navigatorKey.currentState?.pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => WelcomeScreen()),
//             (Route<dynamic> route) => false,
//           );
//         }
//         //   final overlayState = navigatorKey.currentState?.overlay;
//         // if (overlayState != null) {
//         //   final message = 'Session expired, Please login again';
//         //   final icon = Icons.warning;
//         //   final color = const Color.fromARGB(255, 231, 200, 0);
//         //   LoginScreen(overlayState, message, icon, color);
//         // }
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// extension on Response {
//   String? get accessToken => null;
// }
