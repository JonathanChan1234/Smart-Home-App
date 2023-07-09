import 'package:json_annotation/json_annotation.dart';

part 'shade_properties.g.dart';

@JsonSerializable()
class ShadeProperties {
  const ShadeProperties({this.level});

  factory ShadeProperties.fromJson(Map<String, dynamic> json) =>
      _$ShadePropertiesFromJson(json);

  final int? level;

  ShadeProperties copyWith({
    int Function()? level,
  }) {
    return ShadeProperties(level: level != null ? level() : this.level);
  }

  Map<String, dynamic> toJson() => _$ShadePropertiesToJson(this);
}
