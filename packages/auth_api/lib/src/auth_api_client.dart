import 'dart:convert';

import 'package:auth_api/src/models/logout_request.dart';
import 'package:auth_api/src/models/models.dart';
import 'package:auth_api/src/models/refresh_token_request.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthBadRequestException implements Exception {
  const AuthBadRequestException({required this.message});
  final String message;
}

class AuthFailureException implements Exception {}

class ServerInternalFailure implements Exception {}

class AuthApiClient {
  AuthApiClient({http.Client? httpClient, String? url})
      : _httpClient = httpClient ?? http.Client(),
        url = url ?? testUrl;

  static String testUrl = 'http://10.0.2.2:5181/api/v1';
  final http.Client _httpClient;
  final String url;
  final Map<String, String> _jsonHeader = {'Content-Type': 'application/json'};

  void _handleResponseError(Response response) {
    if (response.statusCode == 400) {
      final errorMessage = ErrorMessage.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      throw AuthBadRequestException(message: errorMessage.message);
    }

    if (response.statusCode == 401) {
      throw AuthFailureException();
    }

    if (response.statusCode == 500) {
      throw ServerInternalFailure();
    }
  }

  Future<AuthResponse> login(String userName, String password) async {
    final loginRequest = Uri.parse('$url/auth/login');
    final body = jsonEncode(
        AuthRequest(userName: userName, password: password).toJson());
    final loginResponse =
        await _httpClient.post(loginRequest, body: body, headers: _jsonHeader);

    _handleResponseError(loginResponse);
    final bodyJson = jsonDecode(loginResponse.body) as Map<String, dynamic>;

    return AuthResponse.fromJson(bodyJson);
  }

  Future<AuthResponse> register(
      String email, String userName, String password) async {
    final registerRequest = Uri.parse('$url/auth/register');
    final body = jsonEncode(
        RegisterRequest(email: email, userName: userName, password: password)
            .toJson());
    final registerResponse = await _httpClient.post(registerRequest,
        body: body, headers: _jsonHeader);

    _handleResponseError(registerResponse);

    final bodyJson = jsonDecode(registerResponse.body) as Map<String, dynamic>;

    return AuthResponse.fromJson(bodyJson);
  }

  Future<AuthResponse> refreshToken(
      String accessToken, String refreshToken) async {
    final refreshTokenRequest = Uri.parse('$url/auth/refreshToken');
    final body = jsonEncode(RefreshTokenRequest(
      accessToken: accessToken,
      refreshToken: refreshToken,
    ).toJson());

    final refreshTokenResponse = await _httpClient.post(refreshTokenRequest,
        body: body, headers: _jsonHeader);

    _handleResponseError(refreshTokenResponse);

    final bodyJson =
        jsonDecode(refreshTokenResponse.body) as Map<String, dynamic>;

    return AuthResponse.fromJson(bodyJson);
  }

  Future<void> logout(String accessToken, String refreshToken) async {
    final logoutRequest = Uri.parse('$url/auth/logout');
    final body = jsonEncode(LogoutRequest(refreshToken: refreshToken));
    Map<String, String> requestHeaders = {
      ..._jsonHeader,
      'Authorization': 'Bearer $accessToken'
    };
    final logoutResponse = await _httpClient.post(logoutRequest,
        body: body, headers: requestHeaders);

    _handleResponseError(logoutResponse);
  }
}
