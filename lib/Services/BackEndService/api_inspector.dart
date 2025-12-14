import 'dart:developer';

import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('👉 Request: ${options.method} ${options.uri}');
    log('📦 Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ Response: ${response.statusCode}');
    log('📦 Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ Error: ${err.message}');
    log('⚠️ Status: ${err.response?.statusCode}');
    super.onError(err, handler);
  }
}
