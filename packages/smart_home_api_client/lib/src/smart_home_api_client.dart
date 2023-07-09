import 'package:dio/dio.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

import 'models/error_message.dart';

class SmartHomeApiException extends DioError {
  const SmartHomeApiException({
    message,
    required super.requestOptions,
    required this.code,
  }) : super(message: message);

  final ErrorCode code;
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
                message: 'Network is poor, please try later',
                code: ErrorCode.networkIssue));
          }

          switch (response.statusCode) {
            case 400:
              return handler.reject(SmartHomeApiException(
                  message: ErrorMessage.fromJson(
                          e.response?.data as Map<String, dynamic>)
                      .message,
                  requestOptions: e.requestOptions,
                  code: ErrorCode.badRequest));
            case 401:
              return handler.reject(SmartHomeApiException(
                message: 'Unauthenticated',
                requestOptions: e.requestOptions,
                code: ErrorCode.badAuthentication,
              ));
            case 403:
              return handler.reject(SmartHomeApiException(
                message: 'Unauthorized',
                requestOptions: e.requestOptions,
                code: ErrorCode.forbidden,
              ));
            case 404:
              return handler.reject(SmartHomeApiException(
                message: ErrorMessage.fromJson(
                        e.response?.data as Map<String, dynamic>)
                    .message,
                requestOptions: e.requestOptions,
                code: ErrorCode.resourceNotFound,
              ));
            case 500:
              return handler.reject(SmartHomeApiException(
                message: 'Something is wrong',
                requestOptions: e.requestOptions,
                code: ErrorCode.serverInternalError,
              ));
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
    try {
      return _dio.get(path,
          queryParameters: queryParameter,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
    } on SmartHomeApiException catch (e) {
      throw SmartHomeException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<Response> httpPost({
    required String path,
    String? body,
    String? accessToken,
  }) {
    try {
      return _dio.post(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
    } on SmartHomeApiException catch (e) {
      throw SmartHomeException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<Response> httpPut({
    required String path,
    String? body,
    String? accessToken,
  }) {
    try {
      return _dio.put(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
    } on SmartHomeApiException catch (e) {
      throw SmartHomeException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<Response> httpDelete({
    required String path,
    String? body,
    String? accessToken,
  }) {
    try {
      return _dio.delete(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
    } on SmartHomeApiException catch (e) {
      throw SmartHomeException(
        code: e.code,
        message: e.message,
      );
    }
  }
}
