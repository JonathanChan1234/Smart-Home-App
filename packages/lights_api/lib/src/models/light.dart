import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'light.g.dart';

@JsonSerializable()
class Light extends Equatable {
  const Light({
    required this.id,
    required this.roomId,
    required this.name,
    required this.level,
    required this.dimmable,
    required this.statusLastUpdatedAt,
  });

  factory Light.fromJson(Map<String, dynamic> json) => _$LightFromJson(json);

  final String id;
  final String roomId;
  final String name;
  final int level;
  final bool dimmable;
  final DateTime statusLastUpdatedAt;

  Map<String, dynamic> toJson() => _$LightToJson(this);

  Light copyWith({
    String? name,
    int? level,
    DateTime? statusLastUpdatedAt,
  }) {
    return Light(
      id: id,
      roomId: roomId,
      name: name ?? this.name,
      level: level ?? this.level,
      dimmable: dimmable,
      statusLastUpdatedAt: statusLastUpdatedAt ?? this.statusLastUpdatedAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        roomId,
        name,
        level,
        dimmable,
        statusLastUpdatedAt,
      ];
}
