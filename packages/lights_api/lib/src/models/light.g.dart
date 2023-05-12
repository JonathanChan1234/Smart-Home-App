// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Light _$LightFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Light',
      json,
      ($checkedConvert) {
        final val = Light(
          id: $checkedConvert('id', (v) => v as String),
          roomId: $checkedConvert('roomId', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          level: $checkedConvert('level', (v) => v as int),
          dimmable: $checkedConvert('dimmable', (v) => v as bool),
          statusLastUpdatedAt: $checkedConvert(
              'statusLastUpdatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$LightToJson(Light instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'name': instance.name,
      'level': instance.level,
      'dimmable': instance.dimmable,
      'statusLastUpdatedAt': instance.statusLastUpdatedAt.toIso8601String(),
    };
