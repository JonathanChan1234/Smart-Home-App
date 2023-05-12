import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part "smart_home.g.dart";

@JsonSerializable()
class SmartHome extends Equatable {
  const SmartHome({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
  });

  factory SmartHome.fromJson(Map<String, dynamic> json) =>
      _$SmartHomeFromJson(json);

  static const empty =
      SmartHome(id: '--', name: '--', description: '--', ownerId: '--');

  final String id;
  final String name;
  final String description;
  final String ownerId;

  Map<String, dynamic> toJson() => _$SmartHomeToJson(this);

  @override
  List<Object> get props => [id, name, description, ownerId];
}
