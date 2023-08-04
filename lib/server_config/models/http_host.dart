import 'package:formz/formz.dart';

enum HttpHostValidationError { empty, invalid }

class HttpHost extends FormzInput<String, HttpHostValidationError> {
  const HttpHost.pure() : super.pure('');
  const HttpHost.dirty([super.value = '']) : super.dirty();

  static final _ipAddressRegExp =
      RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');
  static final _domainRegExp =
      RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}');

  @override
  HttpHostValidationError? validator(String value) {
    if (value.isEmpty) return HttpHostValidationError.empty;
    if (!_ipAddressRegExp.hasMatch(value) && !_domainRegExp.hasMatch(value)) {
      return HttpHostValidationError.invalid;
    }
    return null;
  }
}

extension HttpHostErrorExtension on HttpHostValidationError {
  String? get message {
    switch (this) {
      case HttpHostValidationError.empty:
        return 'Host cannot be empty';
      case HttpHostValidationError.invalid:
        return 'Invalid host name';
    }
  }
}
