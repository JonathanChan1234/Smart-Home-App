import 'package:formz/formz.dart';

enum UsernameValidationError {
  empty,
  tooLong,
}

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (value.length > 50) return UsernameValidationError.tooLong;
    return null;
  }
}
