part of 'scene_bloc.dart';

enum SceneStatus { initial, loading, success, failure }

class SceneState extends Equatable {
  const SceneState({
    this.status = SceneStatus.initial,
    required this.homeId,
    this.scenes = const [],
    this.error = '',
  });

  final SceneStatus status;
  final String homeId;
  final List<Scene> scenes;
  final String error;

  SceneState copyWith({
    SceneStatus? status,
    List<Scene>? scenes,
    String? error,
  }) {
    return SceneState(
      homeId: homeId,
      status: status ?? this.status,
      scenes: scenes ?? this.scenes,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        status,
        homeId,
        scenes,
        error,
      ];
}
