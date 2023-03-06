import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { empty, invalid, mismatch }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  static final _passwordRegExp =
      RegExp(r'/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)/gm');

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;
    if (_passwordRegExp.hasMatch(value)) {
      return ConfirmPasswordValidationError.invalid;
    }
    if (password != value) return ConfirmPasswordValidationError.mismatch;
    return null;
  }
}

extension ConfirmPasswordErrorMessage on ConfirmPasswordValidationError {
  String? get message {
    switch (this) {
      case ConfirmPasswordValidationError.empty:
        return 'Confirm password cannot be empty';
      case ConfirmPasswordValidationError.invalid:
        return '''Password must have at least 1 uppercase, lowercast and special character''';
      case ConfirmPasswordValidationError.mismatch:
        return 'Password must match';
    }
  }
}
