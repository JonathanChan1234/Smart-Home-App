part of 'scene_action_bloc.dart';

enum SceneActionStatus {
  initial,
  loading,
  success,
  failure,
}

class SceneActionState extends Equatable {
  const SceneActionState({
    required this.home,
    required this.scene,
    this.status = SceneActionStatus.initial,
    this.actions = const [],
    this.error = '',
  });

  final SmartHome home;
  final Scene scene;
  final SceneActionStatus status;
  final List<SceneAction> actions;
  final String error;

  SceneActionState copyWith({
    SmartHome? home,
    Scene? scene,
    SceneActionStatus? status,
    List<SceneAction>? actions,
    String? error,
  }) {
    return SceneActionState(
      home: home ?? this.home,
      scene: scene ?? this.scene,
      status: status ?? this.status,
      actions: actions ?? this.actions,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        home,
        scene,
        status,
        actions,
        error,
      ];
}
