import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  const Room({
    required this.id,
    required this.name,
    required this.floorId,
    required this.isFavorite,
  });

  final String id;
  final String name;
  final String floorId;
  final bool isFavorite;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
