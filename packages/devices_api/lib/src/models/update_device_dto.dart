import 'package:json_annotation/json_annotation.dart';

part 'update_device_dto.g.dart';

@JsonSerializable()
class UpdateDeviceDto {
  const UpdateDeviceDto({
    required this.name,
  });

  factory UpdateDeviceDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateDeviceDtoFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$UpdateDeviceDtoToJson(this);
}
