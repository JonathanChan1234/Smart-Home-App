import 'package:json_annotation/json_annotation.dart';
import 'package:lights_api/lights_api.dart';

part 'light_payload.g.dart';

@JsonSerializable()
class LightPayload {
  const LightPayload({
    this.properties,
    required this.lastUpdatedAt,
    this.onlineStatus,
  });

  factory LightPayload.fromJson(Map<String, dynamic> json) =>
      _$LightPayloadFromJson(json);

  final LightProperties? properties;
  final bool? onlineStatus;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => _$LightPayloadToJson(this);
}
