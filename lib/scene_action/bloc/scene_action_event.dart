part of 'scene_action_bloc.dart';

abstract class SceneActionEvent extends Equatable {
  const SceneActionEvent();

  @override
  List<Object> get props => [];
}

class SceneActionNameChangedEvent extends SceneActionEvent {
  const SceneActionNameChangedEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class SceneActionInitEvent extends SceneActionEvent {
  const SceneActionInitEvent();
}

class SceneActionSubscriptionRequestEvent extends SceneActionEvent {
  const SceneActionSubscriptionRequestEvent();
}
