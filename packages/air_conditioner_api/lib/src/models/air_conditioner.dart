import 'package:air_conditioner_api/src/models/air_conditioner_capabilities.dart';
import 'package:air_conditioner_api/src/models/air_conditioner_properties.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'air_conditioner.g.dart';

@JsonSerializable()
class AirConditioner extends Equatable {
  const AirConditioner({
    required this.id,
    required this.name,
    required this.roomId,
    required this.homeId,
    required this.mainCategory,
    required this.subCategory,
    required this.properties,
    required this.capabilities,
    required this.onlineStatus,
    required this.statusLastUpdatedAt,
  });

  factory AirConditioner.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerFromJson(json);

  final String id;
  final String name;
  final String roomId;
  final String homeId;
  final int mainCategory;
  final int subCategory;
  final AirConditionerProperties properties;
  final AirConditionerCapabilities capabilities;
  final bool onlineStatus;
  final DateTime statusLastUpdatedAt;

  AirConditioner copyWith({
    String? name,
    AirConditionerProperties? properties,
    bool? onlineStatus,
    DateTime? statusLastUpdatedAt,
  }) {
    return AirConditioner(
      id: id,
      name: name ?? this.name,
      roomId: roomId,
      homeId: homeId,
      mainCategory: mainCategory,
      subCategory: subCategory,
      properties: properties != null
          ? this.properties.copyWith(
              properties.fanSpeed,
              properties.operationMode,
              properties.setTemperature,
              properties.roomTemperature)
          : this.properties,
      capabilities: capabilities,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      statusLastUpdatedAt: statusLastUpdatedAt ?? this.statusLastUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$AirConditionerToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        roomId,
        homeId,
        mainCategory,
        subCategory,
        properties,
        capabilities,
        onlineStatus,
        statusLastUpdatedAt,
      ];
}
