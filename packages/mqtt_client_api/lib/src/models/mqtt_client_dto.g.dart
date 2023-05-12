// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'mqtt_client_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttClientDto _$MqttClientDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MqttClientDto',
      json,
      ($checkedConvert) {
        final val = MqttClientDto(
          clientId: $checkedConvert('clientId', (v) => v as int),
          homeId: $checkedConvert('homeId', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
          revoked: $checkedConvert('revoked', (v) => v as bool),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$MqttClientDtoToJson(MqttClientDto instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'homeId': instance.homeId,
      'userId': instance.userId,
      'revoked': instance.revoked,
      'createdAt': instance.createdAt.toIso8601String(),
    };
