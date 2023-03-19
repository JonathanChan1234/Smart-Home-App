import 'package:json_annotation/json_annotation.dart';

part 'update_room_dto.g.dart';

@JsonSerializable()
class UpdateRoomDto {
  const UpdateRoomDto({
    required this.name,
    required this.isFavorite,
  });

  final String name;
  final bool isFavorite;

  factory UpdateRoomDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateRoomDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRoomDtoToJson(this);
}
