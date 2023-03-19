// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'update_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRoomDto _$UpdateRoomDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateRoomDto',
      json,
      ($checkedConvert) {
        final val = UpdateRoomDto(
          name: $checkedConvert('name', (v) => v as String),
          isFavorite: $checkedConvert('isFavorite', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateRoomDtoToJson(UpdateRoomDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isFavorite': instance.isFavorite,
    };
