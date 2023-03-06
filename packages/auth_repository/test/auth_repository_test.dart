import 'package:auth_api/auth_api.dart';
import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockAuthLocalStorageApi extends Mock implements AuthLocalStorageApi {}

void main() {
  late MockAuthApiClient apiClient;
  late MockAuthLocalStorageApi authLocalStorageApi;

  const email = 'test@gmail.com';
  const username = 'jonathan';
  const userId = '12c10897-8f5f-4148-96b8-733c5be9be0e';
  const password = 'password';

  const expiredAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTdWJqZWN0IGZvciBqb25hdGhhbi5sdWNreWRyYXcudGVzdC5jb20iLCJqdGkiOiI0YWFkMjc4MS1hNzY2LTRhMDQtOTNkOC0zZDcxNDZkNDM0OGQiLCJpYXQiOiIyMi8yLzIwMjMgMTg6MTA6MDciLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEyYzEwODk3LThmNWYtNDE0OC05NmI4LTczM2M1YmU5YmUwZSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJqb25hdGhhbiIsInVzZXJJZCI6IjEyYzEwODk3LThmNWYtNDE0OC05NmI4LTczM2M1YmU5YmUwZSIsImV4cCI6MTY3NzA2MDkwNywiaXNzIjoiam9uYXRoYW4ubHVja3lkcmF3LnRlc3QuY29tIiwiYXVkIjoiam9uYXRoYW4ubHVja3lkcmF3LnRlc3QuY29tIn0.HMrGu912d-phGraE8V5Mr5AKYigCUVYEPJ6TzhB66vw';
  const validAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTdWJqZWN0IGZvciBqb25hdGhhbi5sdWNreWRyYXcudGVzdC5jb20iLCJqdGkiOiI0YWFkMjc4MS1hNzY2LTRhMDQtOTNkOC0zZDcxNDZkNDM0OGQiLCJpYXQiOiIyMi8yLzIwMjMgMTg6MTA6MDciLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEyYzEwODk3LThmNWYtNDE0OC05NmI4LTczM2M1YmU5YmUwZSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJqb25hdGhhbiIsInVzZXJJZCI6IjEyYzEwODk3LThmNWYtNDE0OC05NmI4LTczM2M1YmU5YmUwZSIsImV4cCI6MjY3NzA2MDkwNywiaXNzIjoiam9uYXRoYW4ubHVja3lkcmF3LnRlc3QuY29tIiwiYXVkIjoiam9uYXRoYW4ubHVja3lkcmF3LnRlc3QuY29tIn0.TQK6KNn_MTaOg12IgayPrP3cG-GpZCl3ldXaz-463bc';

  const refreshToken = 'refreshToken';

  group('Auth Repository', () {
    setUp(() {
      apiClient = MockAuthApiClient();
      authLocalStorageApi = MockAuthLocalStorageApi();
    });

    AuthRepository createSubject() {
      return AuthRepository(
        authApiClient: apiClient,
        authLocalStorageApi: authLocalStorageApi,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('register', () {
      test('successful registeration', () async {
        when(() => apiClient.register(email, username, password)).thenAnswer(
            (_) async => const AuthResponse(
                accessToken: validAccessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).thenAnswer((_) async => true);

        final authenticationRepo = createSubject();
        final response = await authenticationRepo.register(
            email: email, username: username, password: password);
        verify(() => apiClient.register(email, username, password)).called(1);
        verify(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).called(1);
        expect(
            response,
            isA<AuthUser>()
                .having((a) => a.id, 'id', userId)
                .having((a) => a.name, 'name', username));
        expect(
            authenticationRepo.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
              AuthenticationStatus.authenticated
            ]));
      });

      test('fail registeration', () async {
        when(() => apiClient.register(email, username, password))
            .thenAnswer((_) async => throw Exception());
        when(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).thenAnswer((_) async => true);

        final authenticationRepo = createSubject();
        try {
          final response = await authenticationRepo.register(
              email: email, username: username, password: password);
          expect(response, isNull);
        } catch (_) {}

        verify(() => apiClient.register(email, username, password)).called(1);
        verifyNever(() =>
            authLocalStorageApi.storeAuthToken(validAccessToken, refreshToken));
        expect(
            authenticationRepo.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
            ]));
      });
    });

    group('login', () {
      test('successful login', () async {
        when(() => apiClient.login(username, password)).thenAnswer((_) async =>
            const AuthResponse(
                accessToken: validAccessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).thenAnswer((_) async => true);
        final authRepo = createSubject();
        try {
          final response =
              await authRepo.logIn(username: username, password: password);
          expect(
              response,
              isA<AuthUser>()
                  .having((a) => a.id, 'id', userId)
                  .having((a) => a.name, 'name', username));
        } catch (_) {}
        verify(() => apiClient.login(username, password)).called(1);
        verify(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).called(1);
        expect(
            authRepo.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
              AuthenticationStatus.authenticated
            ]));
      });

      test('login failure', () async {
        when(() => apiClient.login(username, password))
            .thenAnswer((_) async => throw Exception());
        when(() => authLocalStorageApi.storeAuthToken(any(), any()))
            .thenAnswer((_) async => true);
        final authRepo = createSubject();
        try {
          final response =
              await authRepo.logIn(username: username, password: password);
          expect(response, isNull);
        } catch (_) {}
        verify(() => apiClient.login(username, password)).called(1);
        verifyNever(() =>
            authLocalStorageApi.storeAuthToken(validAccessToken, refreshToken));
        expect(
            authRepo.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
            ]));
      });
    });

    group('Get Auth Token', () {
      test('No auth token in local storage', () async {
        when(() => authLocalStorageApi.getAuthToken()).thenReturn(null);
        when(() => apiClient.refreshToken(any(), any())).thenAnswer((_) async =>
            const AuthResponse(
                accessToken: validAccessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(any(), any()))
            .thenAnswer((_) async => true);

        final authRepo = createSubject();
        try {
          final token = await authRepo.getAuthToken();
          expect(token, isNull);
        } catch (_) {}
        verify(() => authLocalStorageApi.getAuthToken()).called(1);
        verifyNever(
            () => apiClient.refreshToken(validAccessToken, refreshToken));
        verifyNever(() =>
            authLocalStorageApi.storeAuthToken(validAccessToken, refreshToken));
      });

      test('Invalid jwt', () async {
        const accessToken = 'accessToken';
        const authToken =
            AuthToken(accessToken: accessToken, refreshToken: refreshToken);

        when(() => authLocalStorageApi.getAuthToken()).thenReturn(authToken);
        when(() => apiClient.refreshToken(any(), any())).thenAnswer((_) async =>
            const AuthResponse(
                accessToken: accessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(any(), any()))
            .thenAnswer((_) async => true);

        final authRepo = createSubject();
        try {
          final response = await authRepo.getAuthToken();
          expect(response, isNull);
        } catch (_) {}
        verify(() => authLocalStorageApi.getAuthToken()).called(1);
        verifyNever(() => apiClient.refreshToken(accessToken, refreshToken));
        verifyNever(() =>
            authLocalStorageApi.storeAuthToken(accessToken, refreshToken));
      });

      test('jwt not expired', () async {
        const authToken = AuthToken(
            accessToken: validAccessToken, refreshToken: refreshToken);

        when(() => authLocalStorageApi.getAuthToken()).thenReturn(authToken);
        when(() => apiClient.refreshToken(any(), any())).thenAnswer((_) async =>
            const AuthResponse(
                accessToken: validAccessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(any(), any()))
            .thenAnswer((_) async => true);

        final authRepo = createSubject();
        try {
          final token = await authRepo.getAuthToken();
          expect(
              token,
              isA<AuthToken>()
                  .having((a) => a.accessToken, 'accessToken', validAccessToken)
                  .having((a) => a.refreshToken, 'refreshToken', refreshToken));
        } catch (_) {}
        verify(() => authLocalStorageApi.getAuthToken()).called(1);
        verifyNever(
            () => apiClient.refreshToken(validAccessToken, refreshToken));
        verifyNever(() =>
            authLocalStorageApi.storeAuthToken(validAccessToken, refreshToken));
      });

      test('jwt expired, get new token from api', () async {
        const authToken = AuthToken(
            accessToken: expiredAccessToken, refreshToken: refreshToken);

        when(() => authLocalStorageApi.getAuthToken()).thenReturn(authToken);
        when(() => apiClient.refreshToken(any(), any())).thenAnswer((_) async =>
            const AuthResponse(
                accessToken: validAccessToken, refreshToken: refreshToken));
        when(() => authLocalStorageApi.storeAuthToken(any(), any()))
            .thenAnswer((_) async => true);

        final authRepo = createSubject();
        try {
          final token = await authRepo.getAuthToken();
          expect(
              token,
              isA<AuthToken>()
                  .having((a) => a.accessToken, 'accessToken', validAccessToken)
                  .having((a) => a.refreshToken, 'refreshToken', refreshToken));
        } catch (_) {}
        verify(() => authLocalStorageApi.getAuthToken()).called(1);
        verify(() => apiClient.refreshToken(expiredAccessToken, refreshToken))
            .called(1);
        verify(() => authLocalStorageApi.storeAuthToken(
            validAccessToken, refreshToken)).called(1);
      });
    });

    test('jwt expired, bad auth exception when called refresh token api',
        () async {
      const authToken = AuthToken(
          accessToken: expiredAccessToken, refreshToken: refreshToken);

      when(() => authLocalStorageApi.getAuthToken()).thenReturn(authToken);
      when(() => apiClient.refreshToken(any(), any()))
          .thenAnswer((_) async => throw AuthBadRequestException());
      when(() => authLocalStorageApi.storeAuthToken(any(), any()))
          .thenAnswer((_) async => true);

      final authRepo = createSubject();
      try {
        final token = await authRepo.getAuthToken();
        expect(token, null);
      } catch (_) {}
      expect(
          authRepo.status,
          emitsInOrder([
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.unauthenticated
          ]));
      verify(() => authLocalStorageApi.getAuthToken()).called(1);
      verify(() => apiClient.refreshToken(expiredAccessToken, refreshToken))
          .called(1);
      verifyNever(() =>
          authLocalStorageApi.storeAuthToken(expiredAccessToken, refreshToken));
    });

    test('jwt expired, other exception when called refresh token api',
        () async {
      const authToken = AuthToken(
          accessToken: expiredAccessToken, refreshToken: refreshToken);

      when(() => authLocalStorageApi.getAuthToken()).thenReturn(authToken);
      when(() => apiClient.refreshToken(any(), any()))
          .thenAnswer((_) async => throw Exception());
      when(() => authLocalStorageApi.storeAuthToken(any(), any()))
          .thenAnswer((_) async => true);

      final authRepo = createSubject();
      try {
        final token = await authRepo.getAuthToken();
        expect(token, null);
      } catch (_) {}
      expect(
          authRepo.status,
          emitsInOrder([
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.unknown
          ]));
      verify(() => authLocalStorageApi.getAuthToken()).called(1);
      verify(() => apiClient.refreshToken(expiredAccessToken, refreshToken))
          .called(1);
      verifyNever(
          () => authLocalStorageApi.storeAuthToken(any(), refreshToken));
    });
  });
}
