part of 'scene_action_edit_bloc.dart';

abstract class SceneActionEditEvent extends Equatable {
  const SceneActionEditEvent();

  @override
  List<Object> get props => [];
}

class SceneActionEditSubmittedEvent<T extends DeviceAction>
    extends SceneActionEditEvent {
  const SceneActionEditSubmittedEvent({
    required this.category,
    required this.device,
    required this.deviceProperties,
  });

  final DeviceMainCategory category;
  final Device device;
  final T deviceProperties;
}
