part of 'scene_action_device_bloc.dart';

enum SceneActionDeviceStatus { initial, loading, success, failure }

class SceneActionDeviceState extends Equatable {
  const SceneActionDeviceState({
    this.status = SceneActionDeviceStatus.initial,
    required this.scene,
    this.devices = const [],
    this.error = '',
  });

  final SceneActionDeviceStatus status;
  final Scene scene;
  final List<Device> devices;
  final String error;

  SceneActionDeviceState copyWith({
    SceneActionDeviceStatus? status,
    Scene? scene,
    List<Device>? devices,
    String? error,
  }) {
    return SceneActionDeviceState(
      status: status ?? this.status,
      scene: scene ?? this.scene,
      devices: devices ?? this.devices,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        status,
        scene,
        devices,
        error,
      ];
}
