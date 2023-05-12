import 'package:json_annotation/json_annotation.dart';

part 'update_light_dto.g.dart';

@JsonSerializable()
class UpdateLightDto {
  const UpdateLightDto({required this.name});

  factory UpdateLightDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateLightDtoFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$UpdateLightDtoToJson(this);
}
