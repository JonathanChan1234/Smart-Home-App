import 'package:air_conditioner_api/src/models/fan_speed.dart';
import 'package:air_conditioner_api/src/models/operation_mode.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'air_conditioner_properties.g.dart';

@JsonSerializable()
class AirConditionerProperties extends Equatable {
  const AirConditionerProperties({
    this.fanSpeed,
    this.operationMode,
    this.setTemperature,
    this.roomTemperature,
  });

  factory AirConditionerProperties.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerPropertiesFromJson(json);

  final FanSpeed? fanSpeed;
  final OperationMode? operationMode;
  final double? setTemperature;
  final double? roomTemperature;

  AirConditionerProperties copyWith(
    FanSpeed? fanSpeed,
    OperationMode? operationMode,
    double? setTemperature,
    double? roomTemperature,
  ) {
    return AirConditionerProperties(
      fanSpeed: fanSpeed ?? this.fanSpeed,
      operationMode: operationMode ?? this.operationMode,
      setTemperature: setTemperature ?? this.setTemperature,
      roomTemperature: roomTemperature ?? this.roomTemperature,
    );
  }

  Map<String, dynamic> toJson() => _$AirConditionerPropertiesToJson(this);

  @override
  List<Object?> get props =>
      [fanSpeed, operationMode, setTemperature, roomTemperature];
}
