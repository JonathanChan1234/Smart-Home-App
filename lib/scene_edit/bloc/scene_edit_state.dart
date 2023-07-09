part of 'scene_edit_bloc.dart';

enum SceneEditStatus { initial, loading, success, failure }

enum SceneEditEventType { edit, delete }

extension SceneEditStatusX on SceneEditStatus {
  bool get isLoadingOrSuccess {
    return this == SceneEditStatus.loading || this == SceneEditStatus.success;
  }
}

class SceneEditState extends Equatable {
  const SceneEditState({
    this.status = SceneEditStatus.initial,
    required this.scene,
    this.eventType = SceneEditEventType.edit,
    this.name = '',
    this.requestError = '',
  });

  final SceneEditStatus status;
  final SceneEditEventType eventType;
  final Scene scene;
  final String name;
  final String requestError;

  SceneEditState copyWith({
    SceneEditStatus? status,
    SceneEditEventType? eventType,
    Scene? scene,
    String? name,
    String? requestError,
  }) {
    return SceneEditState(
      status: status ?? this.status,
      eventType: eventType ?? this.eventType,
      scene: scene ?? this.scene,
      name: name ?? this.name,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [
        status,
        eventType,
        scene,
        name,
        requestError,
      ];
}
