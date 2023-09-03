import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'air_conditioner_capabilities.g.dart';

@JsonSerializable()
class AirConditionerCapabilities extends Equatable {
  const AirConditionerCapabilities({
    required this.quietFanSpeed,
    required this.lowFanSpeed,
    required this.mediumFanSpeed,
    required this.highFanSpeed,
    required this.topFanSpeed,
    required this.autoFanSpeed,
    required this.fanMode,
    required this.heatMode,
    required this.coolMode,
    required this.dryMode,
    required this.autoMode,
    required this.setTemperatureHighEnd,
    required this.setTemperatureLowEnd,
    required this.showRoomTemperature,
  });

  factory AirConditionerCapabilities.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerCapabilitiesFromJson(json);

  final bool quietFanSpeed;
  final bool lowFanSpeed;
  final bool mediumFanSpeed;
  final bool highFanSpeed;
  final bool topFanSpeed;
  final bool autoFanSpeed;
  final bool fanMode;
  final bool heatMode;
  final bool coolMode;
  final bool dryMode;
  final bool autoMode;
  final double setTemperatureHighEnd;
  final double setTemperatureLowEnd;
  final bool showRoomTemperature;

  FanSpeed? get defaultFanSpeed => quietFanSpeed
      ? FanSpeed.quiet
      : lowFanSpeed
          ? FanSpeed.low
          : mediumFanSpeed
              ? FanSpeed.medium
              : highFanSpeed
                  ? FanSpeed.high
                  : topFanSpeed
                      ? FanSpeed.top
                      : autoFanSpeed
                          ? FanSpeed.auto
                          : null;

  OperationMode? get defaultOperationMode => fanMode
      ? OperationMode.fan
      : heatMode
          ? OperationMode.heat
          : coolMode
              ? OperationMode.cool
              : dryMode
                  ? OperationMode.dry
                  : autoMode
                      ? OperationMode.auto
                      : null;

  Map<String, dynamic> toJson() => _$AirConditionerCapabilitiesToJson(this);

  @override
  List<Object?> get props => [
        quietFanSpeed,
        lowFanSpeed,
        mediumFanSpeed,
        highFanSpeed,
        topFanSpeed,
        autoFanSpeed,
        fanMode,
        heatMode,
        coolMode,
        dryMode,
        autoMode,
        setTemperatureHighEnd,
        setTemperatureLowEnd,
        showRoomTemperature
      ];
}
