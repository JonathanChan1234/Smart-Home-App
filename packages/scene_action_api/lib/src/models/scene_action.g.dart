// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneAction _$SceneActionFromJson(Map<String, dynamic> json) => SceneAction(
      id: json['id'] as String,
      description: json['description'] as String,
      deviceId: json['deviceId'] as String,
      device: Device.fromJson(json['device'] as Map<String, dynamic>),
      action: json['action'] as Map<String, dynamic>,
      sceneId: json['sceneId'] as String,
    );

Map<String, dynamic> _$SceneActionToJson(SceneAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'deviceId': instance.deviceId,
      'device': instance.device,
      'action': instance.action,
      'sceneId': instance.sceneId,
    };
