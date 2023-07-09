// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LightProperties _$LightPropertiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LightProperties',
      json,
      ($checkedConvert) {
        final val = LightProperties(
          brightness: $checkedConvert('brightness', (v) => v as int?),
          colorTemperature:
              $checkedConvert('colorTemperature', (v) => v as int?),
        );
        return val;
      },
    );

Map<String, dynamic> _$LightPropertiesToJson(LightProperties instance) =>
    <String, dynamic>{
      'brightness': instance.brightness,
      'colorTemperature': instance.colorTemperature,
    };
