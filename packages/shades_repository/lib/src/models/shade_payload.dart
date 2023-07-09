import 'package:json_annotation/json_annotation.dart';
import 'package:shades_api/shades_api.dart';

part 'shade_payload.g.dart';

@JsonSerializable()
class ShadePayload {
  const ShadePayload({
    required this.properties,
    required this.time,
  });

  factory ShadePayload.fromJson(Map<String, dynamic> json) =>
      _$ShadePayloadFromJson(json);

  final ShadeProperties properties;
  final DateTime time;

  Map<String, dynamic> toJson() => _$ShadePayloadToJson(this);
}
