import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scene_action_api/scene_action_api.dart';

part 'air_conditioner_action.g.dart';

@JsonSerializable()
class AirConditionerAction extends DeviceAction {
  const AirConditionerAction({
    required this.power,
    this.fanSpeed,
    this.operationMode,
    this.setTemperature,
  });

  factory AirConditionerAction.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerActionFromJson(json);

  final bool power;
  final FanSpeed? fanSpeed;
  final OperationMode? operationMode;
  final double? setTemperature;

  @override
  Map<String, dynamic> toJson() => _$AirConditionerActionToJson(this);
}
