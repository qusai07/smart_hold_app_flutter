class ApiConfig {
  static String baseUrl = 'http://192.168.1.115:5300/SmartApp';
  static const String apiVersion = 'api';

  static String buildPath(String endpoint) {
    return '$baseUrl/$apiVersion/$endpoint'
        .replaceAll(RegExp(r'/+'), '/')
        .replaceAll(':/', '://');
  }
}
