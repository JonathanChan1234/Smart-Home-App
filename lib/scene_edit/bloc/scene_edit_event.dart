part of 'scene_edit_bloc.dart';

abstract class SceneEditEvent extends Equatable {
  const SceneEditEvent();

  @override
  List<Object> get props => [];
}

class SceneEditNameChangedEvent extends SceneEditEvent {
  const SceneEditNameChangedEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class SceneEditSubmittedEvent extends SceneEditEvent {
  const SceneEditSubmittedEvent();
}

class SceneEditDeleteEvent extends SceneEditEvent {
  const SceneEditDeleteEvent();
}
