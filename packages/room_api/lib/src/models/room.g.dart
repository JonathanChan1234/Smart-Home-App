// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Room',
      json,
      ($checkedConvert) {
        final val = Room(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          floorId: $checkedConvert('floorId', (v) => v as String),
          isFavorite: $checkedConvert('isFavorite', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'floorId': instance.floorId,
      'isFavorite': instance.isFavorite,
    };
