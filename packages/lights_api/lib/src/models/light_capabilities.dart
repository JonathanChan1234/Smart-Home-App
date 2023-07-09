import 'package:json_annotation/json_annotation.dart';

part 'light_capabilities.g.dart';

@JsonSerializable()
class LightCapabilities {
  const LightCapabilities({
    required this.dimmable,
    required this.hasColorTemperature,
  });

  factory LightCapabilities.fromJson(Map<String, dynamic> json) =>
      _$LightCapabilitiesFromJson(json);

  final bool dimmable;
  final bool hasColorTemperature;

  Map<String, dynamic> toJson() => _$LightCapabilitiesToJson(this);
}
