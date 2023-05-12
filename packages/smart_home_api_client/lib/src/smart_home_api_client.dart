import 'package:dio/dio.dart';

import 'models/error_message.dart';

class SmartHomeApiException extends DioError {
  const SmartHomeApiException({
    message,
    required super.requestOptions,
  }) : super(message: message);
}

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
            return handler.reject(SmartHomeApiException(
                requestOptions: e.requestOptions,
                message: 'Network is poor, please try later'));
          }

          switch (response.statusCode) {
            case 400:
              return handler.reject(SmartHomeApiException(
                  message: ErrorMessage.fromJson(
                          e.response?.data as Map<String, dynamic>)
                      .message,
                  requestOptions: e.requestOptions));
            case 401:
              return handler.reject(SmartHomeApiException(
                  message: 'Unauthenticated',
                  requestOptions: e.requestOptions));
            case 403:
              return handler.reject(SmartHomeApiException(
                  message: 'Unauthorized', requestOptions: e.requestOptions));
            case 404:
              return handler.reject(SmartHomeApiException(
                  message: ErrorMessage.fromJson(
                          e.response?.data as Map<String, dynamic>)
                      .message,
                  requestOptions: e.requestOptions));
            case 500:
              return handler.reject(SmartHomeApiException(
                  message: 'Something is wrong',
                  requestOptions: e.requestOptions));
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
