import 'package:json_annotation/json_annotation.dart';
import 'package:shades_repository/src/models/shade_action.dart';

part 'shade_control_dto.g.dart';

@JsonSerializable()
class ShadeControlDto {
  const ShadeControlDto({
    required this.properties,
    required this.lastUpdatedAt,
  });

  factory ShadeControlDto.fromJson(Map<String, dynamic> json) =>
      _$ShadeControlDtoFromJson(json);

  final ShadeAction properties;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => _$ShadeControlDtoToJson(this);
}
