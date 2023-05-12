// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_light_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLightDto _$UpdateLightDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateLightDto',
      json,
      ($checkedConvert) {
        final val = UpdateLightDto(
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateLightDtoToJson(UpdateLightDto instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
