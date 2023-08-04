import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'scene_action_device_event.dart';
part 'scene_action_device_state.dart';

class SceneActionDeviceBloc
    extends Bloc<SceneActionDeviceEvent, SceneActionDeviceState> {
  SceneActionDeviceBloc({
    required Scene scene,
    required SceneActionRepository sceneActionRepository,
  })  : _sceneActionRepository = sceneActionRepository,
        super(SceneActionDeviceState(scene: scene)) {
    on<SceneActionDeviceInitEvent>(_onSceneActionDeviceInit);
    on<SceneActionDeviceSubscriptionRequestEvent>(
      _onSceneActionDeviceSubscriptionRequested,
    );
  }

  final SceneActionRepository _sceneActionRepository;

  Future<void> _onSceneActionDeviceInit(
    SceneActionDeviceInitEvent event,
    Emitter<SceneActionDeviceState> emit,
  ) async {
    emit(state.copyWith(status: SceneActionDeviceStatus.loading));
    await _sceneActionRepository.fetchSceneDevice(
      homeId: state.scene.homeId,
      sceneId: state.scene.id,
    );
  }

  Future<void> _onSceneActionDeviceSubscriptionRequested(
    SceneActionDeviceSubscriptionRequestEvent event,
    Emitter<SceneActionDeviceState> emit,
  ) async {
    emit(state.copyWith(status: SceneActionDeviceStatus.loading));
    await emit.forEach(
      _sceneActionRepository.devices,
      onData: (devices) => state.copyWith(
        status: SceneActionDeviceStatus.success,
        devices: devices,
        error: '',
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: SceneActionDeviceStatus.failure,
        error:
            error is SmartHomeException ? error.message : 'Something is wrong',
      ),
    );
  }
}
