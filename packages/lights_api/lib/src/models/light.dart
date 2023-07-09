import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'light_capabilities.dart';
import 'light_properties.dart';

part 'light.g.dart';

@JsonSerializable()
class Light extends Equatable {
  const Light({
    required this.id,
    required this.homeId,
    required this.roomId,
    required this.name,
    required this.mainCategory,
    required this.subCategory,
    required this.properties,
    required this.capabilities,
    required this.onlineStatus,
    required this.statusLastUpdatedAt,
  });

  factory Light.fromJson(Map<String, dynamic> json) => _$LightFromJson(json);

  final String id;
  final String homeId;
  final String roomId;
  final String name;
  final int mainCategory;
  final int subCategory;
  final LightProperties properties;
  final LightCapabilities capabilities;
  final bool onlineStatus;
  final DateTime statusLastUpdatedAt;

  Map<String, dynamic> toJson() => _$LightToJson(this);

  Light copyWith({
    String? name,
    LightProperties? properties,
    bool? onlineStatus,
    DateTime? statusLastUpdatedAt,
  }) {
    return Light(
      id: id,
      homeId: homeId,
      roomId: roomId,
      name: name ?? this.name,
      properties: properties ?? this.properties,
      statusLastUpdatedAt: statusLastUpdatedAt ?? this.statusLastUpdatedAt,
      capabilities: capabilities,
      mainCategory: mainCategory,
      subCategory: subCategory,
      onlineStatus: onlineStatus ?? this.onlineStatus,
    );
  }

  @override
  List<Object> get props => [
        id,
        roomId,
        homeId,
        name,
        mainCategory,
        subCategory,
        properties,
        capabilities,
        onlineStatus,
        statusLastUpdatedAt,
      ];
}
