import 'package:json_annotation/json_annotation.dart';

part 'update_shade_dto.g.dart';

@JsonSerializable()
class UpdateShadeDto {
  const UpdateShadeDto({required this.name});

  factory UpdateShadeDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateShadeDtoFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$UpdateShadeDtoToJson(this);
}
