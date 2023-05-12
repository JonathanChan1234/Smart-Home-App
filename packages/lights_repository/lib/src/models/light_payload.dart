import 'package:json_annotation/json_annotation.dart';

part 'light_payload.g.dart';

@JsonSerializable()
class LightPayload {
  const LightPayload({
    required this.brightness,
    required this.time,
  });

  factory LightPayload.fromJson(Map<String, dynamic> json) =>
      _$LightPayloadFromJson(json);

  final int brightness;
  final DateTime time;

  Map<String, dynamic> toJson() => _$LightPayloadToJson(this);
}
