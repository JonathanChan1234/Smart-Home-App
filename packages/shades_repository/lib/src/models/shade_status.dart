import 'package:json_annotation/json_annotation.dart';
import 'package:shades_repository/src/models/shade_payload.dart';

part 'shade_status.g.dart';

@JsonSerializable()
class ShadeStatus {
  const ShadeStatus({
    required this.payload,
    required this.deviceId,
  });

  factory ShadeStatus.fromJson(Map<String, dynamic> json) =>
      _$ShadeStatusFromJson(json);

  final ShadePayload payload;
  final String deviceId;

  Map<String, dynamic> toJson() => _$ShadeStatusToJson(this);
}
