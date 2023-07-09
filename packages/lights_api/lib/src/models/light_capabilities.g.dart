// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LightCapabilities _$LightCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LightCapabilities',
      json,
      ($checkedConvert) {
        final val = LightCapabilities(
          dimmable: $checkedConvert('dimmable', (v) => v as bool),
          hasColorTemperature:
              $checkedConvert('hasColorTemperature', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$LightCapabilitiesToJson(LightCapabilities instance) =>
    <String, dynamic>{
      'dimmable': instance.dimmable,
      'hasColorTemperature': instance.hasColorTemperature,
    };
