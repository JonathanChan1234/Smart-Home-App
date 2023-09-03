import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'air_conditioner_payload.g.dart';

@JsonSerializable()
class AirConditionerPayload {
  const AirConditionerPayload({
    this.properties,
    required this.lastUpdatedAt,
    this.onlineStatus,
  });

  factory AirConditionerPayload.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerPayloadFromJson(json);

  final AirConditionerProperties? properties;
  final bool? onlineStatus;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => _$AirConditionerPayloadToJson(this);
}
