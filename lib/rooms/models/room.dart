import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:room_api/room_api.dart' as room_api;

part 'room.g.dart';

@JsonSerializable()
class Room extends Equatable {
  const Room({
    required this.id,
    required this.name,
    required this.isFavorite,
    required this.floorId,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  factory Room.fromRepository(room_api.Room room) => Room(
        id: room.id,
        name: room.name,
        isFavorite: room.isFavorite,
        floorId: room.floorId,
      );

  final String id;
  final String name;
  final String floorId;
  final bool isFavorite;

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  List<Object> get props => [id, name, floorId, isFavorite];
}
