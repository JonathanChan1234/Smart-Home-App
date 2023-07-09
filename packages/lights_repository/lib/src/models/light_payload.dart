import 'package:json_annotation/json_annotation.dart';
import 'package:lights_api/lights_api.dart';

part 'light_payload.g.dart';

@JsonSerializable()
class LightPayload {
  const LightPayload({
    required this.properties,
    required this.time,
  });

  factory LightPayload.fromJson(Map<String, dynamic> json) =>
      _$LightPayloadFromJson(json);

  final LightProperties properties;
  final DateTime time;

  Map<String, dynamic> toJson() => _$LightPayloadToJson(this);
}
