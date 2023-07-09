import 'package:json_annotation/json_annotation.dart';

part 'scene_dto.g.dart';

@JsonSerializable()
class SceneDto {
  const SceneDto({
    required this.name,
  });

  factory SceneDto.fromJson(Map<String, dynamic> json) =>
      _$SceneDtoFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$SceneDtoToJson(this);
}
