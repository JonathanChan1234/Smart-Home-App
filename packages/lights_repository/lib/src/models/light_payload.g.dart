// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'light_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LightPayload _$LightPayloadFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LightPayload',
      json,
      ($checkedConvert) {
        final val = LightPayload(
          properties: $checkedConvert(
              'properties',
              (v) => v == null
                  ? null
                  : LightProperties.fromJson(v as Map<String, dynamic>)),
          time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
          onlineStatus: $checkedConvert('onlineStatus', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$LightPayloadToJson(LightPayload instance) =>
    <String, dynamic>{
      'properties': instance.properties,
      'onlineStatus': instance.onlineStatus,
      'time': instance.time.toIso8601String(),
    };
