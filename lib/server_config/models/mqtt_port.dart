import 'package:formz/formz.dart';

enum MqttPortValidationError { outOfRange }

class MqttPort extends FormzInput<int, MqttPortValidationError> {
  const MqttPort.pure() : super.pure(80);
  const MqttPort.dirty([super.value = 80]) : super.dirty();

  @override
  MqttPortValidationError? validator(int value) {
    if (value <= 0 || value > 65535) return MqttPortValidationError.outOfRange;
    return null;
  }
}

extension MqttPortErrorExtension on MqttPortValidationError {
  String? get message {
    switch (this) {
      case MqttPortValidationError.outOfRange:
        return 'MQTT Port out of range';
    }
  }
}
