import 'package:json_annotation/json_annotation.dart';

part "smart_home.g.dart";

@JsonSerializable()
class SmartHome {
  const SmartHome({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
  });

  final String id;
  final String name;
  final String description;
  final String ownerId;

  Map<String, dynamic> toJson() => _$SmartHomeToJson(this);

  factory SmartHome.fromJson(Map<String, dynamic> json) =>
      _$SmartHomeFromJson(json);
}
