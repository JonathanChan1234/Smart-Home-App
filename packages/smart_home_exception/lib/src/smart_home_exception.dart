class SmartHomeException implements Exception {
  const SmartHomeException({
    required this.code,
    this.message,
  });

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
