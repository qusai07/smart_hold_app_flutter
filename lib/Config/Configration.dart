import 'package:smart_hold_app/Security/Secure_Storage';

class Configration {
  static String? appVersion;

  static Future<dynamic> isUptoDate() async {
    final config = await getIt<AuthService>().getConfig();
    final localVersion = await SecureStorageApi.instance.getVersion();
    await SecureStorageApi.instance.setIpAddress(config['ipAddress']);

    if (config['version'] != localVersion) {
      return {'version': config['version'], 'url': config['url']};
    }
    return config['version'] == localVersion;
  }
}
