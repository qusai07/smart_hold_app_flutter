import 'package:dio/Dio.dart';
import 'package:smart_hold_app/Config/api_config.dart';
import 'package:smart_hold_app/Security/token_manager.dart';

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
