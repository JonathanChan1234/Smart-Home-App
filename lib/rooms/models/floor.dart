import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:room_api/room_api.dart' as room_api;
import 'package:smart_home/rooms/models/room.dart';

part 'floor.g.dart';

@JsonSerializable()
class Floor extends Equatable {
  const Floor({
    required this.name,
    required this.id,
    required this.homeId,
    required this.rooms,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);

  factory Floor.fromRepository(room_api.Floor floor) => Floor(
        name: floor.name,
        id: floor.id,
        homeId: floor.homeId,
        rooms: floor.rooms.map(Room.fromRepository).toList(),
      );

  final String name;
  final String id;
  final String homeId;
  final List<Room> rooms;

  Map<String, dynamic> toJson() => _$FloorToJson(this);

  @override
  List<Object> get props => [name, id, homeId, rooms];
}
