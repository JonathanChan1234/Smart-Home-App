import 'package:json_annotation/json_annotation.dart';

part 'shade.g.dart';

@JsonSerializable()
class Shade {
  const Shade({
    required this.id,
    required this.roomId,
    required this.name,
    required this.level,
    required this.hasLevel,
    required this.statusLastUpdatedAt,
  });

  factory Shade.fromJson(Map<String, dynamic> json) => _$ShadeFromJson(json);

  final String id;
  final String roomId;
  final String name;
  final int level;
  final bool hasLevel;
  final DateTime statusLastUpdatedAt;

  Map<String, dynamic> toJson() => _$ShadeToJson(this);
}
