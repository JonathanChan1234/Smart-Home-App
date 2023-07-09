// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scene _$SceneFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Scene',
      json,
      ($checkedConvert) {
        final val = Scene(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          homeId: $checkedConvert('homeId', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SceneToJson(Scene instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'homeId': instance.homeId,
    };
