part of 'scene_action_device_bloc.dart';

abstract class SceneActionDeviceEvent extends Equatable {
  const SceneActionDeviceEvent();

  @override
  List<Object> get props => [];
}

class SceneActionDeviceInitEvent extends SceneActionDeviceEvent {
  const SceneActionDeviceInitEvent();
}

class SceneActionDeviceSubscriptionRequestEvent extends SceneActionDeviceEvent {
  const SceneActionDeviceSubscriptionRequestEvent();
}
