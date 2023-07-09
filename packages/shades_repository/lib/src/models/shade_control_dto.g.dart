// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_control_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeControlDto _$ShadeControlDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShadeControlDto',
      json,
      ($checkedConvert) {
        final val = ShadeControlDto(
          action: $checkedConvert(
              'action', (v) => ShadeAction.fromJson(v as Map<String, dynamic>)),
          time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadeControlDtoToJson(ShadeControlDto instance) =>
    <String, dynamic>{
      'action': instance.action.toJson(),
      'time': instance.time.toIso8601String(),
    };
