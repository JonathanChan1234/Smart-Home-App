// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditioner _$AirConditionerFromJson(Map<String, dynamic> json) =>
    AirConditioner(
      id: json['id'] as String,
      name: json['name'] as String,
      roomId: json['roomId'] as String,
      homeId: json['homeId'] as String,
      mainCategory: json['mainCategory'] as int,
      subCategory: json['subCategory'] as int,
      properties: AirConditionerProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      capabilities: AirConditionerCapabilities.fromJson(
          json['capabilities'] as Map<String, dynamic>),
      onlineStatus: json['onlineStatus'] as bool,
      statusLastUpdatedAt:
          DateTime.parse(json['statusLastUpdatedAt'] as String),
    );

Map<String, dynamic> _$AirConditionerToJson(AirConditioner instance) =>
    <String, dynamic>{
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
