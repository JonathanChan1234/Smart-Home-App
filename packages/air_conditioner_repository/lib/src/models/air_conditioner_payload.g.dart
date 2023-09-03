// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditionerPayload _$AirConditionerPayloadFromJson(
        Map<String, dynamic> json) =>
    AirConditionerPayload(
      properties: json['properties'] == null
          ? null
          : AirConditionerProperties.fromJson(
              json['properties'] as Map<String, dynamic>),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      onlineStatus: json['onlineStatus'] as bool?,
    );

Map<String, dynamic> _$AirConditionerPayloadToJson(
        AirConditionerPayload instance) =>
    <String, dynamic>{
      'properties': instance.properties,
      'onlineStatus': instance.onlineStatus,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };
