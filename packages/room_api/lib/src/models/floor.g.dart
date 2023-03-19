// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'floor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Floor _$FloorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Floor',
      json,
      ($checkedConvert) {
        final val = Floor(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          homeId: $checkedConvert('homeId', (v) => v as String),
          rooms: $checkedConvert(
              'rooms',
              (v) => (v as List<dynamic>)
                  .map((e) => Room.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$FloorToJson(Floor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'homeId': instance.homeId,
      'rooms': instance.rooms,
    };
