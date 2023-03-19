// GENERATED CODE - DO NOT MODIFY BY HAND

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
          isFavorite: $checkedConvert('isFavorite', (v) => v as bool),
          floorId: $checkedConvert('floorId', (v) => v as String),
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
