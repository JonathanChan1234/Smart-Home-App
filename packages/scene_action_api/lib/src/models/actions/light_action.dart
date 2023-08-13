import 'package:json_annotation/json_annotation.dart';

import 'device_action.dart';

part 'light_action.g.dart';

@JsonSerializable()
class LightAction extends DeviceAction {
  const LightAction({
    this.brightness,
    this.colorTemperature,
  });

  factory LightAction.fromJson(Map<String, dynamic> json) {
    return _$LightActionFromJson(json);
  }

  final int? brightness;
  final int? colorTemperature;

  @override
  Map<String, dynamic> toJson() {
    return _$LightActionToJson(this);
  }
}
