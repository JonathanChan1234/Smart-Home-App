// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      id: json['id'] as String,
      name: json['name'] as String,
      roomId: json['roomId'] as String,
      homeId: json['homeId'] as String,
      mainCategory: json['mainCategory'] as int,
      subCategory: json['subCategory'] as int,
      properties: json['properties'] as Map<String, dynamic>,
      capabilities: json['capabilities'] as Map<String, dynamic>,
      onlineStatus: json['onlineStatus'] as bool,
      statusLastUpdatedAt:
          DateTime.parse(json['statusLastUpdatedAt'] as String),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'roomId': instance.roomId,
      'homeId': instance.homeId,
      'mainCategory': instance.mainCategory,
      'subCategory': instance.subCategory,
      'properties': instance.properties,
      'capabilities': instance.capabilities,
      'onlineStatus': instance.onlineStatus,
      'statusLastUpdatedAt': instance.statusLastUpdatedAt.toIso8601String(),
    };
