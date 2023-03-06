import 'dart:convert';

import 'package:auth_local_storage/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorageApi {
  AuthLocalStorageApi({required SharedPreferences plugin}) : _plugin = plugin;
  static const kAuthTokenKey = '__auth_token_key__';

  final SharedPreferences _plugin;

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  Future<void> storeAuthToken(String accessToken, String refreshToken) {
    final authToken =
        AuthToken(accessToken: accessToken, refreshToken: refreshToken);
    return _setValue(kAuthTokenKey, jsonEncode(authToken.toJson()));
  }

  AuthToken? getAuthToken() {
    final authTokenJson = _getValue(kAuthTokenKey);
    if (authTokenJson == null) return null;
    final authToken = jsonDecode(authTokenJson);
    return AuthToken.fromJson(authToken as Map<String, dynamic>);
  }

  Future<void> clearAuthToken() {
    return _setValue(kAuthTokenKey, '');
  }
}
