import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shades_api/src/models/shade_capabilities.dart';
import 'package:shades_api/src/models/shade_properties.dart';

part 'shade.g.dart';

@JsonSerializable()
class Shade extends Equatable {
  const Shade({
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

  factory Shade.fromJson(Map<String, dynamic> json) => _$ShadeFromJson(json);

  final String id;
  final String homeId;
  final String roomId;
  final String name;
  final int mainCategory;
  final int subCategory;
  final ShadeProperties properties;
  final ShadeCapabilities capabilities;
  final bool onlineStatus;
  final DateTime statusLastUpdatedAt;

  Map<String, dynamic> toJson() => _$ShadeToJson(this);

  Shade copyWith({
    String? id,
    String? homeId,
    String? roomId,
    String? name,
    int? mainCategory,
    int? subCategory,
    ShadeProperties? properties,
    ShadeCapabilities? capabilities,
    bool? onlineStatus,
    DateTime? statusLastUpdatedAt,
  }) {
    return Shade(
      id: id ?? this.id,
      homeId: homeId ?? this.homeId,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      mainCategory: mainCategory ?? this.mainCategory,
      subCategory: subCategory ?? this.subCategory,
      properties: properties ?? this.properties,
      capabilities: capabilities ?? this.capabilities,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      statusLastUpdatedAt: statusLastUpdatedAt ?? this.statusLastUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        homeId,
        roomId,
        mainCategory,
        subCategory,
        properties,
        capabilities,
        onlineStatus,
        statusLastUpdatedAt,
      ];
}
