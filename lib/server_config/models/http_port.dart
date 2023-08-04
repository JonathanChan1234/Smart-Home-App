import 'package:formz/formz.dart';

enum HttpPortValidationError { outOfRange }

class HttpPort extends FormzInput<int, HttpPortValidationError> {
  const HttpPort.pure() : super.pure(80);
  const HttpPort.dirty([super.value = 80]) : super.dirty();

  @override
  HttpPortValidationError? validator(int value) {
    if (value <= 0 || value > 65535) return HttpPortValidationError.outOfRange;
    return null;
  }
}

extension HttpPortErrorExtension on HttpPortValidationError {
  String? get message {
    switch (this) {
      case HttpPortValidationError.outOfRange:
        return 'HTTP Port out of range';
    }
  }
}
