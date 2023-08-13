import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'scene_edit_event.dart';
part 'scene_edit_state.dart';

class SceneEditBloc extends Bloc<SceneEditEvent, SceneEditState> {
  SceneEditBloc({
    required SmartHome home,
    Scene? scene,
    required SceneRepository sceneRepository,
  })  : _sceneRepository = sceneRepository,
        super(
          SceneEditState(
            home: home,
            scene: scene,
            name: scene?.name ?? '',
          ),
        ) {
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
      final scene = state.scene;
      if (scene == null) {
        await _sceneRepository.createScene(
          homeId: state.home.id,
          name: state.name,
        );
      } else {
        await _sceneRepository.updateScene(
          homeId: scene.homeId,
          sceneId: scene.id,
          name: state.name,
        );
      }
      emit(
        state.copyWith(
          status: SceneEditStatus.success,
          eventType: SceneEditEventType.edit,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SceneEditStatus.failure,
          requestError:
              e is SmartHomeException ? e.message : 'Something is wrong',
        ),
      );
    }
  }

  Future<void> _onSceneEditDelete(
    SceneEditDeleteEvent event,
    Emitter<SceneEditState> emit,
  ) async {
    final scene = state.scene;
    if (scene == null) {
      emit(
        state.copyWith(
          status: SceneEditStatus.failure,
          requestError: 'This scene no longer exists in this home',
        ),
      );
      return;
    }
    emit(state.copyWith(status: SceneEditStatus.loading));
    try {
      await _sceneRepository.deleteScene(
        homeId: scene.homeId,
        sceneId: scene.id,
      );
      emit(
        state.copyWith(
          status: SceneEditStatus.success,
          eventType: SceneEditEventType.delete,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SceneEditStatus.failure,
          requestError:
              e is SmartHomeException ? e.message : 'Something is wrong',
        ),
      );
    }
  }
}
