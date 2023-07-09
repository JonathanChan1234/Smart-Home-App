import 'package:json_annotation/json_annotation.dart';

part 'shade_capabilities.g.dart';

@JsonSerializable()
class ShadeCapabilities {
  const ShadeCapabilities({
    required this.hasLevel,
  });

  factory ShadeCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ShadeCapabilitiesFromJson(json);

  final bool hasLevel;

  Map<String, dynamic> toJson() => _$ShadeCapabilitiesToJson(this);
}
