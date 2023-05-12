import 'package:json_annotation/json_annotation.dart';

part 'mqtt_client_dto.g.dart';

@JsonSerializable()
class MqttClientDto {
  const MqttClientDto({
    required this.clientId,
    required this.homeId,
    required this.userId,
    required this.revoked,
    required this.createdAt,
  });

  factory MqttClientDto.fromJson(Map<String, dynamic> json) =>
      _$MqttClientDtoFromJson(json);

  final int clientId;
  final String homeId;
  final String userId;
  final bool revoked;
  final DateTime createdAt;

  MqttClientDto copyWith(
      {int? clientId,
      String? homeId,
      String? userId,
      bool? revoked,
      DateTime? createdAt}) {
    return MqttClientDto(
      clientId: clientId ?? this.clientId,
      homeId: homeId ?? this.homeId,
      userId: userId ?? this.userId,
      revoked: revoked ?? this.revoked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => _$MqttClientDtoToJson(this);
}
