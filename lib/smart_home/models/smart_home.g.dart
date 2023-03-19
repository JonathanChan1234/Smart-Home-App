// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartHome _$SmartHomeFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SmartHome',
      json,
      ($checkedConvert) {
        final val = SmartHome(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          ownerId: $checkedConvert('ownerId', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SmartHomeToJson(SmartHome instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ownerId': instance.ownerId,
    };
