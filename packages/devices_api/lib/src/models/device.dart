import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  const Device({
    required this.deviceType,
    required this.numberOfDevices,
  });
  static const String light = 'light';
  static const String shade = 'shade';

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  final String deviceType;
  final int numberOfDevices;

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
