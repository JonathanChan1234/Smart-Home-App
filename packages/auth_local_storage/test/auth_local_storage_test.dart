import 'dart:convert';

import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('AuthLocalStroageApi', () {
    late SharedPreferences plugin;
    const accessToken = 'accessToken';
    const refreshToken = 'refreshToken';
    const authToken =
        AuthToken(accessToken: accessToken, refreshToken: refreshToken);

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(AuthLocalStorageApi.kAuthTokenKey))
          .thenReturn(jsonEncode(authToken.toJson()));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    AuthLocalStorageApi createSubject() {
      return AuthLocalStorageApi(plugin: plugin);
    }

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getAuthToken', () {
      test('get the correct auth token', () {
        final token = createSubject().getAuthToken();
        verify(() => plugin.getString(AuthLocalStorageApi.kAuthTokenKey))
            .called(1);
        expect(
            token,
            isA<AuthToken>()
                .having((a) => a.accessToken, 'accessToken', accessToken)
                .having((a) => a.refreshToken, 'refreshToken', refreshToken));
      });
    });

    group('setAuthToken', () {
      test('set auth token', () async {
        await createSubject().storeAuthToken(accessToken, refreshToken);
        const token =
            AuthToken(accessToken: accessToken, refreshToken: refreshToken);
        verify(() => plugin.setString(
                AuthLocalStorageApi.kAuthTokenKey, json.encode(token.toJson())))
            .called(1);
      });
    });

    group('clearAuthToken', () {
      test('clear auth token', () async {
        expect(createSubject().clearAuthToken(), completes);
      });
    });
  });
}
