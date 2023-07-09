// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'scene_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneDto _$SceneDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SceneDto',
      json,
      ($checkedConvert) {
        final val = SceneDto(
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SceneDtoToJson(SceneDto instance) => <String, dynamic>{
      'name': instance.name,
    };
