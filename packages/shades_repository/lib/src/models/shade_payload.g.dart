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
          lastUpdatedAt: $checkedConvert(
              'lastUpdatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadePayloadToJson(ShadePayload instance) =>
    <String, dynamic>{
      'properties': instance.properties?.toJson(),
      'onlineStatus': instance.onlineStatus,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };
