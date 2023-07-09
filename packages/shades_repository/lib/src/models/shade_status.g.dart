// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeStatus _$ShadeStatusFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ShadeStatus',
      json,
      ($checkedConvert) {
        final val = ShadeStatus(
          payload: $checkedConvert('payload',
              (v) => ShadePayload.fromJson(v as Map<String, dynamic>)),
          deviceId: $checkedConvert('deviceId', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadeStatusToJson(ShadeStatus instance) =>
    <String, dynamic>{
      'payload': instance.payload.toJson(),
      'deviceId': instance.deviceId,
    };
