import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scene_action_api/src/models/device.dart';

part 'scene_action.g.dart';

@JsonSerializable()
class SceneAction extends Equatable {
  const SceneAction({
    required this.id,
    required this.description,
    required this.deviceId,
    required this.device,
    required this.action,
    required this.sceneId,
  });

  factory SceneAction.fromJson(Map<String, dynamic> json) =>
      _$SceneActionFromJson(json);

  final String id;
  final String description;
  final String deviceId;
  final Device device;
  final Map<String, dynamic> action;
  final String sceneId;

  SceneAction copyWithAction({Map<String, dynamic>? action}) {
    return SceneAction(
      id: id,
      description: description,
      deviceId: deviceId,
      device: device,
      action: action ?? this.action,
      sceneId: sceneId,
    );
  }

  Map<String, dynamic> toJson() => _$SceneActionToJson(this);

  @override
  List<Object?> get props => [
        id,
        description,
        deviceId,
        device,
        action,
        sceneId,
      ];
}
