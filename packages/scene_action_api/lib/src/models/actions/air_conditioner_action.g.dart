// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditionerAction _$AirConditionerActionFromJson(
        Map<String, dynamic> json) =>
    AirConditionerAction(
      fanSpeed: $enumDecodeNullable(_$FanSpeedEnumMap, json['fanSpeed']),
      operationMode:
          $enumDecodeNullable(_$OperationModeEnumMap, json['operationMode']),
      setTemperature: (json['setTemperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AirConditionerActionToJson(
        AirConditionerAction instance) =>
    <String, dynamic>{
      'fanSpeed': _$FanSpeedEnumMap[instance.fanSpeed],
      'operationMode': _$OperationModeEnumMap[instance.operationMode],
      'setTemperature': instance.setTemperature,
    };

const _$FanSpeedEnumMap = {
  FanSpeed.quiet: 0,
  FanSpeed.low: 1,
  FanSpeed.medium: 2,
  FanSpeed.high: 3,
  FanSpeed.top: 4,
  FanSpeed.auto: 5,
};

const _$OperationModeEnumMap = {
  OperationMode.fan: 0,
  OperationMode.heat: 1,
  OperationMode.cool: 2,
  OperationMode.dry: 3,
  OperationMode.auto: 4,
};
