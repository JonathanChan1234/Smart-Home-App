import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scene.g.dart';

@JsonSerializable()
class Scene extends Equatable {
  const Scene({
    required this.id,
    required this.name,
    required this.homeId,
  });

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  final String id;
  final String name;
  final String homeId;

  Scene copyWith({
    String? name,
  }) {
    return Scene(
      id: id,
      name: name ?? this.name,
      homeId: homeId,
    );
  }

  Map<String, dynamic> toJson() => _$SceneToJson(this);

  @override
  List<Object> get props => [id, name, homeId];
}
