// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_control_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeControlDto _$ShadeControlDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShadeControlDto',
      json,
      ($checkedConvert) {
        final val = ShadeControlDto(
          properties: $checkedConvert('properties',
              (v) => ShadeAction.fromJson(v as Map<String, dynamic>)),
          lastUpdatedAt: $checkedConvert(
              'lastUpdatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadeControlDtoToJson(ShadeControlDto instance) =>
    <String, dynamic>{
      'properties': instance.properties.toJson(),
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };
