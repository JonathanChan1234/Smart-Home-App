import 'package:json_annotation/json_annotation.dart';
import 'package:shades_api/shades_api.dart';

part 'shade_payload.g.dart';

@JsonSerializable()
class ShadePayload {
  const ShadePayload({
    this.properties,
    this.onlineStatus,
    required this.lastUpdatedAt,
  });

  factory ShadePayload.fromJson(Map<String, dynamic> json) =>
      _$ShadePayloadFromJson(json);

  final ShadeProperties? properties;
  final bool? onlineStatus;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => _$ShadePayloadToJson(this);
}
