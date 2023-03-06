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
    if (_passwordRegExp.hasMatch(value) || value.length < 8) {
      return PasswordValidationError.invalid;
    }
    return null;
  }
}

extension PasswordValidatorErrorMessage on PasswordValidationError {
  String? get message {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Password must not be empty';
      case PasswordValidationError.invalid:
        return '''Password must contain at least 8 characters with at least 1 uppercase, lowercase, numeric and special characters''';
    }
  }
}
