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
          homeId: $checkedConvert('homeId', (v) => v as String),
          roomId: $checkedConvert('roomId', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          mainCategory: $checkedConvert('mainCategory', (v) => v as int),
          subCategory: $checkedConvert('subCategory', (v) => v as int),
          properties: $checkedConvert('properties',
              (v) => LightProperties.fromJson(v as Map<String, dynamic>)),
          capabilities: $checkedConvert('capabilities',
              (v) => LightCapabilities.fromJson(v as Map<String, dynamic>)),
          onlineStatus: $checkedConvert('onlineStatus', (v) => v as bool),
          statusLastUpdatedAt: $checkedConvert(
              'statusLastUpdatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$LightToJson(Light instance) => <String, dynamic>{
      'id': instance.id,
      'homeId': instance.homeId,
      'roomId': instance.roomId,
      'name': instance.name,
      'mainCategory': instance.mainCategory,
      'subCategory': instance.subCategory,
      'properties': instance.properties.toJson(),
      'capabilities': instance.capabilities.toJson(),
      'onlineStatus': instance.onlineStatus,
      'statusLastUpdatedAt': instance.statusLastUpdatedAt.toIso8601String(),
    };
