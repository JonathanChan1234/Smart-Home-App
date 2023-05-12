import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room extends Equatable {
  const Room({
    required this.id,
    required this.name,
    required this.floorId,
    required this.isFavorite,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  final String id;
  final String name;
  final String floorId;
  final bool isFavorite;

  Room copyWith({String? name, String? floorId, bool? isFavorite}) {
    return Room(
      id: id,
      name: name ?? this.name,
      floorId: floorId ?? this.floorId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        floorId,
        isFavorite,
      ];
}
