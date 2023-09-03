// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditionerCapabilities _$AirConditionerCapabilitiesFromJson(
        Map<String, dynamic> json) =>
    AirConditionerCapabilities(
      quietFanSpeed: json['quietFanSpeed'] as bool,
      lowFanSpeed: json['lowFanSpeed'] as bool,
      mediumFanSpeed: json['mediumFanSpeed'] as bool,
      highFanSpeed: json['highFanSpeed'] as bool,
      topFanSpeed: json['topFanSpeed'] as bool,
      autoFanSpeed: json['autoFanSpeed'] as bool,
      fanMode: json['fanMode'] as bool,
      heatMode: json['heatMode'] as bool,
      coolMode: json['coolMode'] as bool,
      dryMode: json['dryMode'] as bool,
      autoMode: json['autoMode'] as bool,
      setTemperatureHighEnd: (json['setTemperatureHighEnd'] as num).toDouble(),
      setTemperatureLowEnd: (json['setTemperatureLowEnd'] as num).toDouble(),
      showRoomTemperature: json['showRoomTemperature'] as bool,
    );

Map<String, dynamic> _$AirConditionerCapabilitiesToJson(
        AirConditionerCapabilities instance) =>
    <String, dynamic>{
      'quietFanSpeed': instance.quietFanSpeed,
      'lowFanSpeed': instance.lowFanSpeed,
      'mediumFanSpeed': instance.mediumFanSpeed,
      'highFanSpeed': instance.highFanSpeed,
      'topFanSpeed': instance.topFanSpeed,
      'autoFanSpeed': instance.autoFanSpeed,
      'fanMode': instance.fanMode,
      'heatMode': instance.heatMode,
      'coolMode': instance.coolMode,
      'dryMode': instance.dryMode,
      'autoMode': instance.autoMode,
      'setTemperatureHighEnd': instance.setTemperatureHighEnd,
      'setTemperatureLowEnd': instance.setTemperatureLowEnd,
      'showRoomTemperature': instance.showRoomTemperature,
    };
