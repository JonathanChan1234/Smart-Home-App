import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'scene_action_event.dart';
part 'scene_action_state.dart';

class SceneActionBloc extends Bloc<SceneActionEvent, SceneActionState> {
  SceneActionBloc({
    required SmartHome home,
    required Scene scene,
    required SceneActionRepository sceneActionRepository,
  })  : _sceneActionRepository = sceneActionRepository,
        super(
          SceneActionState(
            home: home,
            scene: scene,
          ),
        ) {
    on<SceneActionNameChangedEvent>(_onSceneNameChanged);
    on<SceneActionInitEvent>(_onSceneActionInit);
    on<SceneActionSubscriptionRequestEvent>(_onSceneActionSubscriptionRequest);
  }

  final SceneActionRepository _sceneActionRepository;

  void _onSceneNameChanged(
    SceneActionNameChangedEvent event,
    Emitter<SceneActionState> emit,
  ) {
    emit(state.copyWith(scene: state.scene.copyWith(name: event.name)));
  }

  Future<void> _onSceneActionInit(
    SceneActionInitEvent event,
    Emitter<SceneActionState> emit,
  ) async {
    emit(state.copyWith(status: SceneActionStatus.loading));
    await _sceneActionRepository.fetchSceneAction(
      homeId: state.home.id,
      sceneId: state.scene.id,
    );
  }

  Future<void> _onSceneActionSubscriptionRequest(
    SceneActionSubscriptionRequestEvent event,
    Emitter<SceneActionState> emit,
  ) async {
    emit(state.copyWith(status: SceneActionStatus.loading));
    await emit.forEach(
      _sceneActionRepository.actions,
      onData: (actions) {
        return state.copyWith(
          status: SceneActionStatus.success,
          actions: actions,
          error: '',
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          status: SceneActionStatus.failure,
          error: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        );
      },
    );
  }
}
