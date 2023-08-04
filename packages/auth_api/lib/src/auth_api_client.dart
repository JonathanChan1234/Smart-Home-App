import 'dart:convert';

import 'package:auth_api/src/models/models.dart';
import 'package:auth_api/src/models/refresh_token_request.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class AuthApiClient {
  AuthApiClient({required SmartHomeApiClient smartHomeApiClient})
      : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<AuthResponse> login(String userName, String password) async {
    final res = await _smartHomeApiClient.httpPost(
        path: '/auth/login',
        body: jsonEncode(
            AuthRequest(userName: userName, password: password).toJson()));
    final body = res.data;
    if (body == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: 'Empty Body');
    }
    return AuthResponse.fromJson(body as Map<String, dynamic>);
  }

  Future<AuthResponse> register(
    String email,
    String userName,
    String password,
  ) async {
    final res = await _smartHomeApiClient.httpPost(
        path: '/auth/register',
        body: jsonEncode(RegisterRequest(
          email: email,
          userName: userName,
          password: password,
        ).toJson()));
    final body = res.data;
    if (body == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: 'Empty Body');
    }
    return AuthResponse.fromJson(body as Map<String, dynamic>);
  }

  Future<AuthResponse> refreshToken(
    String accessToken,
    String refreshToken,
  ) async {
    final res = await _smartHomeApiClient.httpPost(
        path: '/auth/refreshToken',
        body: jsonEncode(RefreshTokenRequest(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ).toJson()));
    final body = res.data;
    if (body == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: 'Empty Body');
    }
    return AuthResponse.fromJson(body as Map<String, dynamic>);
  }

  Future<void> logout(String accessToken, String refreshToken) async {
    await _smartHomeApiClient.httpPost(
      path: '/auth/logout',
      body: jsonEncode(RefreshTokenRequest(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ).toJson()),
      accessToken: accessToken,
    );
  }
}
