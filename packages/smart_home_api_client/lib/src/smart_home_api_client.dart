import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class SmartHomeApiClient {
  SmartHomeApiClient({
    required SharedPreferences plugin,
    Dio? dio,
    String? url,
  })  : _sharedPreferences = plugin,
        _dio = dio ?? Dio() {
    _dio.options.baseUrl =
        'http://${getServerHost()}:${getServerPort()}/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors
      ..add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            options.headers
                .addEntries({'Content-Type': 'application/json'}.entries);
            return handler.next(options);
          },
          onResponse: (Response response, ResponseInterceptorHandler handler) {
            return handler.next(response);
          },
          onError: (DioException e, ErrorInterceptorHandler handler) {
            return handler.next(e);
          },
        ),
      )
      ..add(RetryInterceptor(
          dio: _dio,
          logPrint: (message) => debugPrint(message),
          retries: 3,
          retryableExtraStatuses: {
            status401Unauthorized
          },
          retryDelays: const [
            Duration(seconds: 3),
            Duration(seconds: 3),
            Duration(seconds: 3),
          ]));
  }

  static const defaultHost = '10.0.2.2';
  static const defaultPort = 5181;
  static const kServerHostKey = '__http_host_key__';
  static const kServerPortKey = '__http_port_key__';
  final Dio _dio;
  final SharedPreferences _sharedPreferences;

  // host: [domain]:[port]
  Future<void> setServerHost({required String host, required int port}) async {
    _dio.options.baseUrl = 'http://$host:$port/api/v1';
    _sharedPreferences.setString(kServerHostKey, host);
    _sharedPreferences.setInt(kServerPortKey, port);
  }

  String getServerHost() {
    final cacheHost = _sharedPreferences.getString(kServerHostKey);
    return cacheHost == null || cacheHost.isEmpty ? defaultHost : cacheHost;
  }

  int getServerPort() {
    final cachePort = _sharedPreferences.getInt(kServerPortKey);
    return cachePort ?? defaultPort;
  }

  Future<Response> httpGet({
    required String path,
    Map<String, String>? queryParameter,
    String? accessToken,
  }) async {
    try {
      final res = await _dio.get(path,
          queryParameters: queryParameter,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
      return res;
    } on DioException catch (e) {
      throw SmartHomeException.fromDioException(e);
    }
  }

  Future<Response> httpPost({
    required String path,
    String? body,
    String? accessToken,
  }) async {
    try {
      final res = await _dio.post(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
      return res;
    } on DioException catch (e) {
      throw SmartHomeException.fromDioException(e);
    }
  }

  Future<Response> httpPut({
    required String path,
    String? body,
    String? accessToken,
  }) async {
    try {
      final res = await _dio.put(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
      return res;
    } on DioException catch (e) {
      throw SmartHomeException.fromDioException(e);
    }
  }

  Future<Response> httpDelete({
    required String path,
    String? body,
    String? accessToken,
  }) async {
    try {
      final res = await _dio.delete(path,
          data: body,
          options: accessToken == null
              ? null
              : Options(
                  headers: {'Authorization': 'Bearer $accessToken'},
                ));
      return res;
    } on DioException catch (e) {
      throw SmartHomeException.fromDioException(e);
    }
  }
}
