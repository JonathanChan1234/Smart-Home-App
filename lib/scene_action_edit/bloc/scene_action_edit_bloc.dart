import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'scene_action_edit_event.dart';
part 'scene_action_edit_state.dart';

class SceneActionEditBloc
    extends Bloc<SceneActionEditEvent, SceneActionEditState> {
  SceneActionEditBloc({
    required SceneActionRepository sceneActionRepository,
    required Scene scene,
    SceneAction? action,
  })  : _sceneActionRepository = sceneActionRepository,
        super(
          SceneActionEditState(
            scene: scene,
            action: action,
          ),
        ) {
    on<SceneActionEditSubmittedEvent>(_onSceneActionEditSubmittedEvent);
    on<SceneActionEditDeletedEvent>(_onSceneActionEditDeletedEvent);
  }

  final SceneActionRepository _sceneActionRepository;

  Future<void> _onSceneActionEditSubmittedEvent<T extends DeviceAction>(
    SceneActionEditSubmittedEvent<T> event,
    Emitter<SceneActionEditState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SceneActionEditStatus.loading,
        eventType: SceneActionEditEventType.edit,
      ),
    );
    try {
      final action = state.action;
      if (action != null) {
        await _sceneActionRepository.updateSceneAction(
          homeId: state.scene.homeId,
          sceneId: state.scene.id,
          actionId: action.id,
          category: event.category,
          dto: DeviceActionDto<T>(
            deviceProperties: event.deviceProperties,
            deviceId: event.device.id,
          ),
        );
      } else {
        await _sceneActionRepository.createSceneAction(
          homeId: state.scene.homeId,
          sceneId: state.scene.id,
          category: event.category,
          dto: DeviceActionDto<T>(
            deviceProperties: event.deviceProperties,
            deviceId: event.device.id,
          ),
        );
      }
      emit(state.copyWith(status: SceneActionEditStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: SceneActionEditStatus.failure,
          requestError: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }

  Future<void> _onSceneActionEditDeletedEvent(
    SceneActionEditDeletedEvent event,
    Emitter<SceneActionEditState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SceneActionEditStatus.loading,
        eventType: SceneActionEditEventType.delete,
      ),
    );
    final action = state.action;
    if (action == null) {
      emit(
        state.copyWith(
          status: SceneActionEditStatus.failure,
          requestError:
              '''Scene action no longer exists. Please go back to scene action page''',
        ),
      );
      return;
    }

    try {
      await _sceneActionRepository.deleteSceneAction(
        homeId: state.scene.homeId,
        sceneId: state.scene.id,
        actionId: action.id,
      );
      emit(state.copyWith(status: SceneActionEditStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: SceneActionEditStatus.failure,
          requestError: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }
}
