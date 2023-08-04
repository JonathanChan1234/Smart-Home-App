// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadePayload _$ShadePayloadFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShadePayload',
      json,
      ($checkedConvert) {
        final val = ShadePayload(
          properties: $checkedConvert(
              'properties',
              (v) => v == null
                  ? null
                  : ShadeProperties.fromJson(v as Map<String, dynamic>)),
          onlineStatus: $checkedConvert('onlineStatus', (v) => v as bool?),
          time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadePayloadToJson(ShadePayload instance) =>
    <String, dynamic>{
      'properties': instance.properties?.toJson(),
      'onlineStatus': instance.onlineStatus,
      'time': instance.time.toIso8601String(),
    };
