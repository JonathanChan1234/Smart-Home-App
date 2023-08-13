import 'package:formz/formz.dart';

enum MqttHostValidationError { empty, invalid }

class MqttHost extends FormzInput<String, MqttHostValidationError> {
  const MqttHost.pure() : super.pure('');
  const MqttHost.dirty([super.value = '']) : super.dirty();

  static final _ipAddressRegExp =
      RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');
  static final _domainRegExp =
      RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}');

  @override
  MqttHostValidationError? validator(String value) {
    if (value.isEmpty) return MqttHostValidationError.empty;
    if (!_ipAddressRegExp.hasMatch(value) && !_domainRegExp.hasMatch(value)) {
      return MqttHostValidationError.invalid;
    }
    return null;
  }
}
