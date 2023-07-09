// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeProperties _$ShadePropertiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShadeProperties',
      json,
      ($checkedConvert) {
        final val = ShadeProperties(
          level: $checkedConvert('level', (v) => v as int?),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadePropertiesToJson(ShadeProperties instance) =>
    <String, dynamic>{
      'level': instance.level,
    };
