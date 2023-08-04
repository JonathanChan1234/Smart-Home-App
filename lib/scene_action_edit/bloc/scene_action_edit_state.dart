part of 'scene_action_edit_bloc.dart';

enum SceneActionEditStatus { initial, loading, success, failure }

enum SceneActionEditEventType { edit, delete }

extension SceneActionEditStatusX on SceneActionEditStatus {
  bool get isLoadingOrSuccess {
    return this == SceneActionEditStatus.loading ||
        this == SceneActionEditStatus.success;
  }
}

class SceneActionEditState extends Equatable {
  const SceneActionEditState({
    this.status = SceneActionEditStatus.initial,
    this.eventType = SceneActionEditEventType.edit,
    required this.scene,
    this.action,
    this.requestError = '',
  });

  final SceneActionEditEventType eventType;
  final SceneActionEditStatus status;
  final Scene scene;
  final SceneAction? action;
  final String? requestError;

  SceneActionEditState copyWith({
    SceneActionEditEventType? eventType,
    SceneActionEditStatus? status,
    Scene? scene,
    SceneAction? action,
    String? requestError,
  }) {
    return SceneActionEditState(
      eventType: eventType ?? this.eventType,
      status: status ?? this.status,
      scene: scene ?? this.scene,
      action: action ?? this.action,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object?> get props => [
        eventType,
        status,
        scene,
        action,
        requestError,
      ];
}
