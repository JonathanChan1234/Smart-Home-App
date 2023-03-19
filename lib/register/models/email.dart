import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalid,
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}

extension EmailErrorExtension on EmailValidationError {
  String? get message {
    switch (this) {
      case EmailValidationError.empty:
        return 'Email cannot be empty';
      case EmailValidationError.invalid:
        return 'Invalid email';
    }
  }
}
