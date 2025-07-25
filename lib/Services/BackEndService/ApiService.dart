import 'package:dio/Dio.dart';
import 'package:smart_hold_app/Config/ApiConfig.dart';
import 'package:smart_hold_app/Security/TokenManager.dart';

class ApiService {
  final Dio dio;
  ApiService()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> post(
    String endpoint, {
    dynamic data,
    required Options options,
  }) async {
    return dio.post(endpoint, data: data);
  }

  Future<Response> get(String endpoint, {required Options options}) async {
    return dio.get(endpoint);
  }
}

// }
//  Future<Response> get(
//     String endpoint, {
//     required Options options,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     try {
//       return await dio.get(
//         endpoint,
//         options: options,
//         queryParameters: queryParameters,
//       );
//     } on DioException catch (e) {
//       handleDioError(e);
//       rethrow;
//     }
//   }
  
//   void handleDioError(DioException e) {
//   }



  // Future<Response?> get(String url, {Map<String, dynamic>? headers}) async {
  //   try {
  //     final response = await apiInspector.dio.get(
  //       url,
  //       options: apiInspector.createOptions(headers: headers),
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     return errorResponse;
  //   }
  // }

  // Future<Response?> getImage(
  //   String url, {
  //   required Map<String, dynamic> headers,
  // }) async {
  //   try {
  //     final response = await apiInspector.dio.get(
  //       url,
  //       options: apiInspector.createOptions(headers: headers, isJson: false),
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     if (errorResponse != null) return errorResponse;
  //     rethrow;
  //   }
  // }

  // Future<Response> post(
  //   String url, {
  //   Map<String, dynamic>? headers,
  //   Object? body,
  // }) async {
  //   try {
  //     final Response response;
  //     if (body is FormData) {
  //       response = (await apiInspector.dio.post(
  //         url,
  //         options: apiInspector.createOptions(
  //           headers: headers,
  //           isMultipart: true,
  //         ),
  //         data: body,
  //       ));
  //     } else {
  //       response = (await apiInspector.dio.post(
  //         url,
  //         options: apiInspector.createOptions(headers: headers),
  //         data: body,
  //       ));
  //     }
  //     return response;
  //   } on DioException catch (e) {
  //     logError('DioException: $e');
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     if (errorResponse != null) return errorResponse;
  //     rethrow;
  //   }
  // }

  // void logError(String message) {
  //   print('ERROR: $message');
  // }

  // Future<Response> put(
  //   String url, {
  //   Map<String, dynamic>? headers,
  //   Object? body,
  // }) async {
  //   try {
  //     final Response response;
  //     if (body is FormData) {
  //       response = (await apiInspector.dio.put(
  //         url,
  //         options: apiInspector.createOptions(
  //           headers: headers,
  //           isMultipart: true,
  //         ),
  //         data: body,
  //       ));
  //     } else {
  //       response = (await apiInspector.dio.put(
  //         url,
  //         options: apiInspector.createOptions(headers: headers),
  //         data: body,
  //       ));
  //     }
  //     return response;
  //   } on DioException catch (e) {
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     if (errorResponse != null) return errorResponse;
  //     rethrow;
  //   }
  // }

  // Future<Response?> putImage(
  //   String url, {
  //   Map<String, dynamic>? headers,
  //   Object? body,
  // }) async {
  //   try {
  //     final response = await apiInspector.dio.put(
  //       url,
  //       options: apiInspector.createOptions(
  //         headers: headers,
  //         isMultipart: true,
  //       ),
  //       data: body,
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     if (errorResponse != null) return errorResponse;
  //     rethrow;
  //   }
  // }

  // Future<Response?> delete(String url, {Map<String, dynamic>? headers}) async {
  //   try {
  //     final response = await apiInspector.dio.delete(
  //       url,
  //       options: apiInspector.createOptions(headers: headers),
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     final errorResponse = await apiInspector.handleError(e, e.requestOptions);
  //     if (errorResponse != null) return errorResponse;
  //     rethrow;
  //   }
  // }
//}
