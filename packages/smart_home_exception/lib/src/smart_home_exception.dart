import 'package:dio/dio.dart';
import 'package:smart_home_exception/src/error_body.dart';

class SmartHomeException implements Exception {
  const SmartHomeException({
    required this.code,
    this.message,
  });

  factory SmartHomeException.fromDioException(DioException e) {
    final response = e.response;
    if (response == null) {
      return const SmartHomeException(
          message: 'Network is poor, please try later',
          code: ErrorCode.networkIssue);
    }

    switch (response.statusCode) {
      case 400:
        return SmartHomeException(
            message:
                ErrorBody.fromJson(e.response?.data as Map<String, dynamic>)
                    .message,
            code: ErrorCode.badRequest);
      case 401:
        return const SmartHomeException(
          message: 'Unauthenticated',
          code: ErrorCode.badAuthentication,
        );
      case 403:
        return const SmartHomeException(
          message: 'Unauthorized',
          code: ErrorCode.forbidden,
        );
      case 404:
        return SmartHomeException(
          message: ErrorBody.fromJson(e.response?.data as Map<String, dynamic>)
              .message,
          code: ErrorCode.resourceNotFound,
        );
      default:
        return const SmartHomeException(
          message: 'Something is wrong',
          code: ErrorCode.serverInternalError,
        );
    }
  }

  final ErrorCode code;
  final String? message;
}

enum ErrorCode {
  emptyBody,
  badRequest,
  badAuthentication,
  badFormat,
  resourceNotFound,
  forbidden,
  serverInternalError,
  networkIssue,
  unknown,
}
