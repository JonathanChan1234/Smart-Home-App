import 'dart:async';

import 'package:auth_api/auth_api.dart';
import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/src/models/auth_user.dart';
import 'package:auth_repository/src/utils/jwt_decode.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  AuthRepository(
      {required AuthApiClient authApiClient,
      required AuthLocalStorageApi authLocalStorageApi})
      : _authApiClient = authApiClient,
        _authLocalStorageApi = authLocalStorageApi;

  final _controller = StreamController<AuthenticationStatus>();
  final AuthApiClient _authApiClient;
  final AuthLocalStorageApi _authLocalStorageApi;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<AuthUser> register(
      {required String email,
      required String username,
      required String password}) async {
    final registerResponse =
        await _authApiClient.register(email, username, password);
    // store the jwt token and login info in local storage
    await _authLocalStorageApi.storeAuthToken(
        registerResponse.accessToken, registerResponse.refreshToken);
    _controller.add(AuthenticationStatus.authenticated);
    return JwtUtils.getAuthUserFromJwt(registerResponse.accessToken);
  }

  Future<AuthUser> logIn({
    required String username,
    required String password,
  }) async {
    final loginResponse = await _authApiClient.login(username, password);

    // store the jwt token and login info in local storage
    await _authLocalStorageApi.storeAuthToken(
        loginResponse.accessToken, loginResponse.refreshToken);

    _controller.add(AuthenticationStatus.authenticated);
    return JwtUtils.getAuthUserFromJwt(loginResponse.accessToken);
  }

  Future<AuthUser?> getCurrentUser() async {
    final authToken = await getAuthToken();
    if (authToken == null) return null;
    return JwtUtils.getAuthUserFromJwt(authToken.accessToken);
  }

  Future<AuthToken?> getAuthToken() async {
    try {
      // Get the jwt from local storage
      final authToken = _authLocalStorageApi.getAuthToken();
      if (authToken == null) return null;

      // Parse the expiration second to DateTime
      // If the accessToken does not expire, return accessToken
      final expireTime = DateTime.fromMillisecondsSinceEpoch(
          JwtUtils.getJwtExpirationTime(authToken.accessToken) * 1000);
      if (expireTime.compareTo(DateTime.now()) > 0) return authToken;

      // Fetch the new token using refresh token if expired
      // Set user to be unauthenticated for bad request and invalid access token
      final newToken = await _authApiClient.refreshToken(
          authToken.accessToken, authToken.refreshToken);
      await _authLocalStorageApi.storeAuthToken(
          newToken.accessToken, newToken.refreshToken);
      return AuthToken(
          accessToken: newToken.accessToken,
          refreshToken: newToken.refreshToken);
    } on JwtParseException {
      _controller.add(AuthenticationStatus.unauthenticated);
    } on AuthBadRequestException {
      _controller.add(AuthenticationStatus.unauthenticated);
    } on AuthFailureException {
      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (_) {
      // Network or other error
      _controller.add(AuthenticationStatus.unknown);
    }
    return null;
  }

  Future<void> logOut() async {
    final authToken = _authLocalStorageApi.getAuthToken();
    if (authToken == null) throw Exception('Missing auth token');
    try {
      await _authApiClient.logout(
          authToken.accessToken, authToken.refreshToken);
      await _authLocalStorageApi.clearAuthToken();
    } catch (_) {}
    // _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
