import 'package:dio/dio.dart';

import 'models/error_message.dart';

class HttpBadRequestException implements Exception {
  const HttpBadRequestException({required this.message});

  final String message;
}

class HttpBadFormatException implements Exception {}

class HttpNotFoundException implements Exception {
  const HttpNotFoundException({required this.message});

  final String message;
}

class HttpBadAuthenticationException implements Exception {}

class HttpInternalServerException implements Exception {}

class HttpNetworkException implements Exception {}

class SmartHomeApiClient {
  SmartHomeApiClient({
    Dio? dio,
    String? url,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = url ?? localServerURL;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          options.headers
              .addEntries({'Content-Type': 'application/json'}.entries);
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) {
          final response = e.response;
          if (response == null) {
            throw HttpNetworkException();
          }

          switch (response.statusCode) {
            case 400:
              throw HttpBadRequestException(
                  message: ErrorMessage.fromJson(
                          e.response?.data as Map<String, dynamic>)
                      .message);
            case 401:
              throw HttpBadAuthenticationException();
            case 403:
              throw HttpBadFormatException();
            case 404:
              throw HttpNotFoundException(
                  message: ErrorMessage.fromJson(
                          e.response?.data as Map<String, dynamic>)
                      .message);
            case 500:
              throw HttpInternalServerException();
          }
          return handler.next(e);
        },
      ),
    );
  }

  static String localServerURL = 'http://10.0.2.2:5181/api/v1';
  final Dio _dio;

  Future<Response> httpGet({
    required String path,
    Map<String, String>? queryParameter,
    String? accessToken,
  }) {
    if (accessToken == null) {
      return _dio.get(path, queryParameters: queryParameter);
    }
    return _dio.get(path,
        queryParameters: queryParameter,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  Future<Response> httpPost({
    required String path,
    required String body,
    String? accessToken,
  }) {
    if (accessToken == null) {
      return _dio.post(path, data: body);
    }
    return _dio.post(path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  Future<Response> httpPut({
    required String path,
    required String body,
    String? accessToken,
  }) {
    if (accessToken == null) {
      return _dio.put(path, data: body);
    }
    return _dio.put(path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  Future<Response> httpDelete({
    required String path,
    required String body,
    String? accessToken,
  }) {
    if (accessToken == null) {
      return _dio.delete(path, data: body);
    }
    return _dio.delete(path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }
}
