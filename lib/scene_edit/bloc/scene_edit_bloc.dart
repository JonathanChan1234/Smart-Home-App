import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';

part 'scene_edit_event.dart';
part 'scene_edit_state.dart';

class SceneEditBloc extends Bloc<SceneEditEvent, SceneEditState> {
  SceneEditBloc({
    required Scene scene,
    required SceneRepository sceneRepository,
  })  : _sceneRepository = sceneRepository,
        super(SceneEditState(scene: scene)) {
    on<SceneEditNameChangedEvent>(_onSceneEditNameChanged);
    on<SceneEditSubmittedEvent>(_onSceneEditSubmitted);
    on<SceneEditDeleteEvent>(_onSceneEditDelete);
  }

  final SceneRepository _sceneRepository;

  void _onSceneEditNameChanged(
    SceneEditNameChangedEvent event,
    Emitter<SceneEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSceneEditSubmitted(
    SceneEditSubmittedEvent event,
    Emitter<SceneEditState> emit,
  ) async {
    emit(state.copyWith(status: SceneEditStatus.loading));
    try {
      await _sceneRepository.updateScene(
        homeId: state.scene.homeId,
        sceneId: state.scene.id,
        name: state.name,
      );
      emit(
        state.copyWith(
          status: SceneEditStatus.success,
          eventType: SceneEditEventType.edit,
          requestError: '',
        ),
      );
    } catch (e) {}
  }

  Future<void> _onSceneEditDelete(
    SceneEditDeleteEvent event,
    Emitter<SceneEditState> emit,
  ) async {
    emit(state.copyWith(status: SceneEditStatus.loading));
    try {
      await _sceneRepository.deleteScene(
        homeId: state.scene.homeId,
        sceneId: state.scene.id,
      );
      emit(
        state.copyWith(
          status: SceneEditStatus.success,
          eventType: SceneEditEventType.delete,
          requestError: '',
        ),
      );
    } catch (e) {}
  }
}
