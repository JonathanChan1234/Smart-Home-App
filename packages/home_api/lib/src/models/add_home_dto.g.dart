// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'add_home_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddHomeDto _$AddHomeDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AddHomeDto',
      json,
      ($checkedConvert) {
        final val = AddHomeDto(
          password: $checkedConvert('password', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AddHomeDtoToJson(AddHomeDto instance) =>
    <String, dynamic>{
      'password': instance.password,
    };
