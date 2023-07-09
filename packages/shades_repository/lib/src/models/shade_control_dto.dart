import 'package:json_annotation/json_annotation.dart';
import 'package:shades_repository/src/models/shade_action.dart';

part 'shade_control_dto.g.dart';

@JsonSerializable()
class ShadeControlDto {
  const ShadeControlDto({
    required this.action,
    required this.time,
  });

  factory ShadeControlDto.fromJson(Map<String, dynamic> json) =>
      _$ShadeControlDtoFromJson(json);

  final ShadeAction action;
  final DateTime time;

  Map<String, dynamic> toJson() => _$ShadeControlDtoToJson(this);
}
