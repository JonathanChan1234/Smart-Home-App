// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditionerProperties _$AirConditionerPropertiesFromJson(
        Map<String, dynamic> json) =>
    AirConditionerProperties(
      fanSpeed: $enumDecodeNullable(_$FanSpeedEnumMap, json['fanSpeed']),
      operationMode:
          $enumDecodeNullable(_$OperationModeEnumMap, json['operationMode']),
      setTemperature: (json['setTemperature'] as num?)?.toDouble(),
      roomTemperature: (json['roomTemperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AirConditionerPropertiesToJson(
        AirConditionerProperties instance) =>
    <String, dynamic>{
      'fanSpeed': _$FanSpeedEnumMap[instance.fanSpeed],
      'operationMode': _$OperationModeEnumMap[instance.operationMode],
      'setTemperature': instance.setTemperature,
      'roomTemperature': instance.roomTemperature,
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
