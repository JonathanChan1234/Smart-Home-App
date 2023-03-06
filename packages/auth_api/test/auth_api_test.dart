import 'dart:convert';

import 'package:auth_api/auth_api.dart';
import 'package:auth_api/src/models/logout_request.dart';
import 'package:auth_api/src/models/refresh_token_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('AuthApiClient', () {
    late http.Client httpClient;
    late AuthApiClient apiClient;
    Map<String, String> jsonHeader = {'Content-Type': 'application/json'};

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = AuthApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(AuthApiClient(), isNotNull);
      });
    });

    group('login', () {
      const username = 'user';
      const password = 'password';
      final body = jsonEncode(
          const AuthRequest(userName: username, password: password).toJson());

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any())).thenAnswer((_) async => response);
        try {
          await apiClient.login(username, password);
        } catch (_) {}
        verify(
          () => httpClient.post(
              Uri.parse('${AuthApiClient.testUrl}/auth/login'),
              body: body,
              headers: jsonHeader),
        ).called(1);
      });

      test('throws AuthBadRequestException on 400 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        expect(
          () async => apiClient.login(username, password),
          throwsA(isA<AuthBadRequestException>()),
        );
      });

      test('throws AuthFailureException on 401 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(401);
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        await expectLater(
          apiClient.login(username, password),
          throwsA(isA<AuthFailureException>()),
        );
      });

      test('returns token and expiration on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
  "accessToken": "accessToken",
    "refreshToken": "refreshToken"
}''',
        );
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        final actual = await apiClient.login(username, password);
        expect(
            actual,
            isA<AuthResponse>()
                .having((l) => l.accessToken, 'accessToken', 'accessToken')
                .having((l) => l.refreshToken, 'refreshToken', 'refreshToken'));
      });
    });

    group('register', () {
      const username = 'user';
      const password = 'password';
      const email = 'user@email.com';
      final body = jsonEncode(const RegisterRequest(
              email: email, userName: username, password: password)
          .toJson());

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        try {
          await apiClient.register(email, username, password);
        } catch (_) {}
        verify(
          () => httpClient.post(
              Uri.parse('${AuthApiClient.testUrl}/auth/register'),
              body: body,
              headers: jsonHeader),
        ).called(1);
      });

      test('throws AuthBadRequestException on 400 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        expect(
          () async => apiClient.register(email, username, password),
          throwsA(isA<AuthBadRequestException>()),
        );
      });

      test('throws AuthFailureException on 401 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(401);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        await expectLater(
          apiClient.register(email, username, password),
          throwsA(isA<AuthFailureException>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
  "accessToken": "accessToken",
    "refreshToken": "refreshToken"
}''',
        );
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        final actual = await apiClient.register(email, username, password);
        expect(
            actual,
            isA<AuthResponse>()
                .having((l) => l.accessToken, 'accessToken', 'accessToken')
                .having((l) => l.refreshToken, 'refreshToken', 'refreshToken'));
      });
    });

    group('refreshToken', () {
      const accessToken = 'accessToken';
      const refreshToken = 'refreshToken';
      final body = jsonEncode(const RefreshTokenRequest(
              accessToken: accessToken, refreshToken: refreshToken)
          .toJson());

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        try {
          await apiClient.refreshToken(accessToken, refreshToken);
        } catch (_) {}
        verify(
          () => httpClient.post(
              Uri.parse('${AuthApiClient.testUrl}/auth/refreshToken'),
              body: body,
              headers: jsonHeader),
        ).called(1);
      });

      test('throws AuthBadRequestException on 400 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        expect(
          () async => apiClient.refreshToken(accessToken, refreshToken),
          throwsA(isA<AuthBadRequestException>()),
        );
      });

      test('throws AuthFailureException on 401 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(401);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        await expectLater(
          apiClient.refreshToken(accessToken, refreshToken),
          throwsA(isA<AuthFailureException>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
  "accessToken": "accessToken",
    "refreshToken": "refreshToken"
}''',
        );
        when(() => httpClient.post(any(), body: body, headers: jsonHeader))
            .thenAnswer((_) async => response);
        final actual = await apiClient.refreshToken(accessToken, refreshToken);
        expect(
            actual,
            isA<AuthResponse>()
                .having((l) => l.accessToken, 'accessToken', 'accessToken')
                .having((l) => l.refreshToken, 'refreshToken', 'refreshToken'));
      });
    });

    group('logout', () {
      const accessToken = 'accessToken';
      const refreshToken = 'refreshToken';
      final body =
          jsonEncode(const LogoutRequest(refreshToken: refreshToken).toJson());
      Map<String, String> headers = {
        ...jsonHeader,
        'Authorization': 'Bearer $accessToken'
      };

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: headers))
            .thenAnswer((_) async => response);
        try {
          await apiClient.logout(accessToken, refreshToken);
        } catch (_) {}
        verify(
          () => httpClient.post(
            Uri.parse('${AuthApiClient.testUrl}/auth/logout'),
            body: body,
            headers: headers,
          ),
        ).called(1);
      });

      test('throws AuthBadRequestException on 400 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.post(any(), body: body, headers: headers))
            .thenAnswer((_) async => response);
        expect(
          () async => apiClient.logout(accessToken, refreshToken),
          throwsA(isA<AuthBadRequestException>()),
        );
      });

      test('throws AuthFailureException on 401 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(401);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any(), body: body, headers: headers))
            .thenAnswer((_) async => response);
        await expectLater(
          apiClient.logout(accessToken, refreshToken),
          throwsA(isA<AuthFailureException>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''''',
        );
        when(() => httpClient.post(any(), body: body, headers: headers))
            .thenAnswer((_) async => response);
        expect(apiClient.logout(accessToken, refreshToken), completes);
      });
    });
  });
}
