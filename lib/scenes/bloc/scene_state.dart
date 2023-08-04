part of 'scene_bloc.dart';

enum SceneStatus { initial, loading, success, failure }

enum SceneActivateStatus { initial, loading, success, failure }

class SceneState extends Equatable {
  const SceneState({
    this.status = SceneStatus.initial,
    this.activateStatus = SceneActivateStatus.initial,
    required this.homeId,
    this.activateScene,
    this.scenes = const [],
    this.error = '',
  });

  final SceneStatus status;
  final SceneActivateStatus activateStatus;
  final Scene? activateScene;
  final String homeId;
  final List<Scene> scenes;
  final String error;

  SceneState copyWith({
    SceneStatus? status,
    SceneActivateStatus? activateStatus,
    Scene? activateScene,
    List<Scene>? scenes,
    String? error,
  }) {
    return SceneState(
      homeId: homeId,
      status: status ?? this.status,
      activateStatus: activateStatus ?? this.activateStatus,
      activateScene: activateScene,
      scenes: scenes ?? this.scenes,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        homeId,
        activateStatus,
        activateScene,
        scenes,
        error,
      ];
}
