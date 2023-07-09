import 'package:json_annotation/json_annotation.dart';

part 'light_properties.g.dart';

@JsonSerializable()
class LightProperties {
  const LightProperties({
    this.brightness,
    this.colorTemperature,
  });

  factory LightProperties.fromJson(Map<String, dynamic> json) =>
      _$LightPropertiesFromJson(json);

  final int? brightness;
  final int? colorTemperature;

  LightProperties copyWith({
    int? Function()? brightness,
    int? Function()? colorTemperature,
  }) {
    return LightProperties(
      brightness: brightness != null ? brightness() : this.brightness,
      colorTemperature:
          colorTemperature != null ? colorTemperature() : this.colorTemperature,
    );
  }

  Map<String, dynamic> toJson() => _$LightPropertiesToJson(this);
}
