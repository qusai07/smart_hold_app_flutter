import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorage() : secureStorage = const FlutterSecureStorage();

  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String _role = 'role';
  static const String _guid = 'guid';
  static const String _version = 'version';
  static const String _ipAddress = 'ipAddress';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await secureStorage.write(key: accessTokenKey, value: accessToken);
      await secureStorage.write(key: refreshTokenKey, value: refreshToken);
    } catch (e) {
      logError('Error storing tokens: $e');
      throw InternalException('Error storing tokens in secure storage');
    }
  }

  Future<void> write({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await secureStorage.read(key: key);
  }

  Future<void> setVersion(String? value) async {
    try {
      await secureStorage.write(key: _version, value: value);
    } catch (e) {
      logError('Error storing Version: $e');
      throw InternalException('Error storing Version in secure storage');
    }
  }

  Future<String?> getVersion() async {
    try {
      return await secureStorage.read(key: _version) ?? '1.0.7';
    } catch (e) {
      logError('Error reading Version: $e');
      throw InternalException('Error reading Version in secure storage');
    }
  }

  Future<void> setIpAddress(String? value) async {
    try {
      await secureStorage.write(key: _ipAddress, value: value);
    } catch (e) {
      logError('Error storing IpAddress: $e');
      throw InternalException('Error storing IpAddress in secure storage');
    }
  }

  Future<String?> getIpAddress() async {
    try {
      return await secureStorage.read(key: _ipAddress);
    } catch (e) {
      logError('Error reading IpAddress: $e');
      throw InternalException('Error reading IpAddress in secure storage');
    }
  }

  Future<void> setGuid(String? value) async {
    try {
      await secureStorage.write(key: _guid, value: value);
    } catch (e) {
      logError('Error storing Guid: $e');
      throw InternalException('Error storing Guid in secure storage');
    }
  }

  Future<String?> getGuid() async {
    try {
      return await secureStorage.read(key: _guid);
    } catch (e) {
      logError('Error reading Guid: $e');
      throw InternalException('Error reading Guid in secure storage');
    }
  }

  Future<void> setRole(String? value) async {
    try {
      await secureStorage.write(key: _role, value: value);
    } catch (e) {
      logError('Error storing Role: $e');
      throw InternalException('Error storing Role in secure storage');
    }
  }

  Future<String?> getRole() async {
    try {
      return await secureStorage.read(key: _role);
    } catch (e) {
      logError('Error reading Role: $e');
      throw InternalException('Error reading Role in secure storage');
    }
  }

  Future<void> setAccessToken(String? value) async {
    await secureStorage.write(key: accessTokenKey, value: value);
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: accessTokenKey);
  }

  Future<void> setRefreshToken(String? value) async {
    await secureStorage.write(key: refreshTokenKey, value: value);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: accessTokenKey);
    await secureStorage.delete(key: refreshTokenKey);
  }

  Future<bool> isUserLoggedIn() async {
    final refreshToken = await getRefreshToken();
    return refreshToken != null;
  }

  Future<void> logout() async {
    try {
      await secureStorage.deleteAll();
    } catch (e) {
      logError('Error during logout: $e');
      throw InternalException('Error during logout in secure storage');
    }
  }

  void logError(String message) {
    print('SecureStorage Error: $message');
  }
}

class InternalException implements Exception {
  final String message;
  InternalException(this.message);

  @override
  String toString() => 'InternalException: $message';
}
