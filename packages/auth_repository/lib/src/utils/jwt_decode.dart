import 'dart:convert';

import 'package:auth_repository/src/models/auth_user.dart';

class JwtParseException implements Exception {
  final String message;
  JwtParseException(this.message);
}

class JwtUtils {
  static const usernameClaims =
      "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name";
  static const userIdClaims =
      "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier";

  static AuthUser getAuthUserFromJwt(String token) {
    final payload = _parseJwt(token);
    if (payload[userIdClaims] == null || payload[usernameClaims] == null) {
      throw JwtParseException('invalid jwt');
    }
    return AuthUser(name: payload[usernameClaims], id: payload[userIdClaims]);
  }

  static int getJwtExpirationTime(String token) {
    final payload = _parseJwt(token);
    if (payload['exp'] == null) throw JwtParseException('Missing exp');
    return payload['exp'] as int;
  }

  // References: https://stackoverflow.com/questions/52017389/how-to-get-the-claims-from-a-jwt-in-my-flutter-application
  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw JwtParseException('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw JwtParseException('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw JwtParseException('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
