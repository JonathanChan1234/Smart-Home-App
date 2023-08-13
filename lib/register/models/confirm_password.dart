import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { empty, invalid, mismatch }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  static final _passwordRegExp =
      RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)');

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (password != value) return ConfirmPasswordValidationError.mismatch;
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;
    if (_passwordRegExp.hasMatch(value)) {
      return ConfirmPasswordValidationError.invalid;
    }
    return null;
  }
}
