import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:room_api/src/models/room.dart';

part 'floor.g.dart';

@JsonSerializable()
class Floor extends Equatable {
  const Floor({
    required this.id,
    required this.name,
    required this.homeId,
    required this.rooms,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);

  final String id;
  final String name;
  final String homeId;
  final List<Room> rooms;

  Floor copyWith({
    String? id,
    String? name,
    String? homeId,
    List<Room>? rooms,
  }) {
    return Floor(
      id: id ?? this.id,
      name: name ?? this.name,
      homeId: homeId ?? this.homeId,
      rooms: rooms ?? this.rooms,
    );
  }

  Map<String, dynamic> toJson() => _$FloorToJson(this);

  @override
  List<Object?> get props => [id, name, homeId, rooms];
}
