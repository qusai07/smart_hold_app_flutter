import 'package:dio/dio.dart';
import 'package:smart_hold_app/Service/Api_Services/Api_Constant.dart';
import 'package:smart_hold_app/Service/Api_Services/Api_Service';

class AuthApi {
  final API api;

  AuthApi(this.api);

  /// Makes a GET request to the server to obtain the client's IP address.
  ///
  /// Returns a [Future] containing the IP address as a [String].
  ///
  /// Throws an exception if the request fails.
  Future<Response> getConfig() async {
    String url = ApiConstants.getConfig;
    Response response = await api.get(url);
    return response;
  }

  /// Sends a POST request to the student login endpoint with the provided
  /// [email], [password], and [deviceId].
  ///
  /// Constructs headers using [deviceId] and a request body with [email] and [password].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> studentSignIn({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    String url = AuthEndpoints.studentLogin;

    final Map<String, dynamic> header = makeHeaders(deviceId, false);

    final Map<String, dynamic> body = makeBody(email, password);

    try {
      Response response = await api.post(url, headers: header, body: body);
      return response;
    } on Exception {
      rethrow;
    }
  }

  /// Sends a GET request to the root endpoint of the API to check if the server is
  /// available.
  ///
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> checkServer() async {
    String url = ApiConstants.baseUrlWithPort;
    Response response = await api.get(url);
    return response;
  }

  /// Sends a POST request to the school login endpoint with the provided
  /// [email], [password], and [deviceId].
  ///
  /// Constructs headers using [deviceId] and a request body with [email] and [password].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> schoolSignIn({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    String url = AuthEndpoints.schoolLogin;

    final Map<String, dynamic> header = makeHeaders(deviceId, false);

    final Map<String, dynamic> body = makeBody(email, password);

    Response response = await api.post(url, headers: header, body: body);
    return response;
  }

  /// Sends a POST request to the guest login endpoint with the provided
  /// [deviceId].
  ///
  /// Constructs a request header with [deviceId].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> guestSignIn({required String deviceId}) async {
    String url = AuthEndpoints.guestLogin;

    final Map<String, dynamic> header = makeHeaders(deviceId, false);

    Response response = await api.post(url, headers: header);
    return response;
  }

  /// Sends a POST request to the guest logout endpoint with the provided
  /// [token].
  ///
  /// Constructs a request header with [token].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> guestSignOut({
    required String token,
    required String guid,
  }) async {
    String url = AuthEndpoints.guestLogout;

    final Map<String, dynamic> body = {"refreshToken": token, 'guid': guid};

    Response response = await api.post(url, body: body);
    return response;
  }

  /// Sends a POST request to the user logout endpoint with the provided
  /// [refreshToken].
  ///
  /// Constructs a request header with [refreshToken].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> logout({required String refreshToken}) async {
    String url = AuthEndpoints.userLogout;

    final Map<String, dynamic> header = makeHeaders(refreshToken, true);

    Response response = await api.post(url, headers: header);
    return response;
  }

  /// Sends a POST request to the refresh token endpoint using the provided
  /// [refreshToken].
  ///
  /// Constructs a request header with [refreshToken].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> refreshToken({required String refreshToken}) async {
    String url = AuthEndpoints.refreshToken;

    final Map<String, dynamic> header = makeHeaders(refreshToken, true);

    Response response = await api.post(url, headers: header);

    return response;
  }

  /// Sends a PUT request to the user password edit endpoint with the provided
  /// [oldPassword], [newPassword], and [token].
  ///
  /// Constructs headers using [token] and a request body with [oldPassword] and [newPassword].
  /// Returns a [Future] containing the server [Response].
  ///
  /// Throws an exception if the request fails.
  Future<Response> editPassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    String url = UserEndpoints.editPassword;

    final Map<String, dynamic> header = {'Authorization': 'Bearer $token'};

    final Map<String, dynamic> body = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    Response response = await api.put(url, headers: header, body: body);
    return response;
  }

  Map<String, String> makeHeaders(String value, bool isToken) {
    if (isToken) {
      return {"refresher-token": value};
    }
    return {'device-id': value};
  }

  Map<String, dynamic> makeBody(String email, String password) {
    return {"userEmail": email, "password": password};
  }
}
