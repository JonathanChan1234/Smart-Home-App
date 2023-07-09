// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_shade_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateShadeDto _$UpdateShadeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateShadeDto',
      json,
      ($checkedConvert) {
        final val = UpdateShadeDto(
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateShadeDtoToJson(UpdateShadeDto instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
