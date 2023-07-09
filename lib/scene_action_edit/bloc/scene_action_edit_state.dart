part of 'scene_action_edit_bloc.dart';

enum SceneActionEditStatus { initial, loading, success, failure }

class SceneActionEditState extends Equatable {
  const SceneActionEditState({
    this.status = SceneActionEditStatus.initial,
    required this.scene,
    this.action,
    this.requestError = '',
  });

  final SceneActionEditStatus status;
  final Scene scene;
  final SceneAction? action;
  final String? requestError;

  SceneActionEditState copyWith({
    SceneActionEditStatus? status,
    Scene? scene,
    SceneAction? action,
    String? requestError,
  }) {
    return SceneActionEditState(
      status: status ?? this.status,
      scene: scene ?? this.scene,
      action: action ?? this.action,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scene,
        action,
        requestError,
      ];
}
