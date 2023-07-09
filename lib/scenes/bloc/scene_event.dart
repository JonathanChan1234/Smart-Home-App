part of 'scene_bloc.dart';

abstract class SceneEvent extends Equatable {
  const SceneEvent();

  @override
  List<Object> get props => [];
}

class SceneListInitEvent extends SceneEvent {
  const SceneListInitEvent();
}

class SceneListSubscriptionRequestedEvent extends SceneEvent {
  const SceneListSubscriptionRequestedEvent();
}
