import 'package:json_annotation/json_annotation.dart';
import 'package:room_api/src/models/room.dart';

part 'floor.g.dart';

@JsonSerializable()
class Floor {
  const Floor({
    required this.id,
    required this.name,
    required this.homeId,
    required this.rooms,
  });

  final String id;
  final String name;
  final String homeId;
  final List<Room> rooms;

  factory Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);
  Map<String, dynamic> toJson() => _$FloorToJson(this);
}
