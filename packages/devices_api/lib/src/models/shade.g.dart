// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shade _$ShadeFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Shade',
      json,
      ($checkedConvert) {
        final val = Shade(
          id: $checkedConvert('id', (v) => v as String),
          roomId: $checkedConvert('roomId', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          level: $checkedConvert('level', (v) => v as int),
          hasLevel: $checkedConvert('hasLevel', (v) => v as bool),
          statusLastUpdatedAt: $checkedConvert(
              'statusLastUpdatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadeToJson(Shade instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'name': instance.name,
      'level': instance.level,
      'hasLevel': instance.hasLevel,
      'statusLastUpdatedAt': instance.statusLastUpdatedAt.toIso8601String(),
    };
