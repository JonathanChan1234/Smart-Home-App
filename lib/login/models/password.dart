import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  invalid,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      RegExp(r'/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)/gm');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (_passwordRegExp.hasMatch(value)) return PasswordValidationError.invalid;
    return null;
  }
}

extension PasswordValidationErrorExtension on PasswordValidationError {
  String get message {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Password cannot be empty';
      case PasswordValidationError.invalid:
        return '''Invalid Password. Password must contain at least 1 uppercase, lowercase and numeric character''';
    }
  }
}
