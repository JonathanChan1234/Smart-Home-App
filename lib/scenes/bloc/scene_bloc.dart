import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'scene_event.dart';
part 'scene_state.dart';

class SceneBloc extends Bloc<SceneEvent, SceneState> {
  SceneBloc({
    required String homeId,
    required SceneRepository sceneRepository,
  })  : _sceneRepository = sceneRepository,
        super(SceneState(homeId: homeId)) {
    on<SceneListInitEvent>(_onSceneListInit);
    on<SceneListSubscriptionRequestedEvent>(_onSceneListSubscriptionRequested);
    on<SceneActivatedEvent>(_onSceneActivated);
  }

  final SceneRepository _sceneRepository;

  Future<void> _onSceneListSubscriptionRequested(
    SceneListSubscriptionRequestedEvent event,
    Emitter<SceneState> emit,
  ) async {
    emit(state.copyWith(status: SceneStatus.loading));
    await emit.forEach(
      _sceneRepository.scenes,
      onData: (scenes) => state.copyWith(
        status: SceneStatus.success,
        scenes: scenes,
        error: '',
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: SceneStatus.failure,
        error:
            error is SmartHomeException ? error.message : 'Something is wrong',
      ),
    );
  }

  Future<void> _onSceneListInit(
    SceneListInitEvent event,
    Emitter<SceneState> emit,
  ) async {
    emit(state.copyWith(status: SceneStatus.loading));
    await _sceneRepository.fetchScenes(homeId: state.homeId);
  }

  void _onSceneActivated(
    SceneActivatedEvent event,
    Emitter<SceneState> emit,
  ) {
    emit(
      state.copyWith(
        activateStatus: SceneActivateStatus.loading,
        activateScene: event.scene,
      ),
    );
    try {
      _sceneRepository.activateScene(
        homeId: state.homeId,
        sceneId: event.scene.id,
      );
      emit(
        state.copyWith(
          activateStatus: SceneActivateStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          activateStatus: SceneActivateStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}
