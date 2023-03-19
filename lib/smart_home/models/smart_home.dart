import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart' as home_api;
import 'package:json_annotation/json_annotation.dart';

part 'smart_home.g.dart';

@JsonSerializable()
class SmartHome extends Equatable {
  const SmartHome({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
  });

  factory SmartHome.fromRepository(home_api.SmartHome smartHome) => SmartHome(
        description: smartHome.description,
        id: smartHome.id,
        ownerId: smartHome.ownerId,
        name: smartHome.name,
      );

  factory SmartHome.fromJson(Map<String, dynamic> json) =>
      _$SmartHomeFromJson(json);

  Map<String, dynamic> toJson() => _$SmartHomeToJson(this);

  final String id;
  final String name;
  final String description;
  final String ownerId;

  @override
  List<Object> get props => [id, name, description, ownerId];
}
