class ApiConfig {
  static String baseUrl = 'http://172.20.10.3:7078/';
  // static String baseUrl = 'http://192.168.1.154:7078/';
  static const String apiVersion = 'api';
  static String buildPath(String endpoint) {
    return '$baseUrl/$apiVersion/$endpoint'
        .replaceAll(RegExp(r'/+'), '/')
        .replaceAll(':/', '://');
  }
}
