import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/lights_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'light_event.dart';
part 'light_state.dart';

class LightBloc extends Bloc<LightEvent, LightState> {
  LightBloc({
    required LightsRepository lightsRepository,
    required HomeRepository homeRepository,
    required SmartHome home,
    required Room room,
  })  : _lightsRepository = lightsRepository,
        _homeRepository = homeRepository,
        super(LightState(home: home, room: room)) {
    on<LightListInitEvent>(_onLightListInit);
    on<LightStatusSubscriptionRequestedEvent>(
      _onLightStatusSubscriptionRequested,
    );
    on<LightStatusChangedEvent>(_onLightStatusChanged);
    on<LightEditModeChangedEvent>(_onLightEditModeChanged);
    on<LightMqttStatusSubscriptionRequestEvent>(
      _onLightMqttStatusSubscriptionRequest,
    );
    on<LightProcessorSubscriptionRequestEvent>(
      _onLightProcessorStatusSubscriptionRequest,
    );
  }

  final LightsRepository _lightsRepository;
  final HomeRepository _homeRepository;

  Future<void> _onLightMqttStatusSubscriptionRequest(
    LightMqttStatusSubscriptionRequestEvent event,
    Emitter<LightState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.serverConnectStatus,
      onData: (status) => state.copyWith(serverStatus: status),
    );
  }

  Future<void> _onLightProcessorStatusSubscriptionRequest(
    LightProcessorSubscriptionRequestEvent event,
    Emitter<LightState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.processorConnectStatus,
      onData: (status) => state.copyWith(processorStatus: status),
    );
  }

  Future<void> _onLightListInit(
    LightListInitEvent event,
    Emitter<LightState> emit,
  ) async {
    emit(state.copyWith(status: LightStatus.loading));
    try {
      await _lightsRepository.fetchLightsInRoom(
        homeId: state.home.id,
        roomId: state.room.id,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LightStatus.failure,
          requestError: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }

  Future<void> _onLightStatusSubscriptionRequested(
    LightStatusSubscriptionRequestedEvent event,
    Emitter<LightState> emit,
  ) async {
    emit(state.copyWith(status: LightStatus.loading));
    _lightsRepository.initLightStatusSubscription(homeId: state.home.id);
    await emit.forEach(
      _lightsRepository.lights,
      onData: (lights) => state.copyWith(
        status: LightStatus.success,
        lights: lights,
        requestError: '',
      ),
      onError: (error, _) => state.copyWith(
        status: LightStatus.failure,
        requestError: (error is SmartHomeException)
            ? error.message
            : 'Something is wrong',
      ),
    );
  }

  void _onLightStatusChanged(
    LightStatusChangedEvent event,
    Emitter<LightState> emit,
  ) {
    if (!state.serverStatus.isConnected) {
      emit(
        state.copyWith(controlError: 'Fail to connect to MQTT server'),
      );
      return;
    }
    if (!state.processorStatus.online) {
      emit(
        state.copyWith(
          controlError: 'Fail to connect with your home processor',
        ),
      );
      return;
    }
    try {
      _lightsRepository.updateLightStatus(
        homeId: state.home.id,
        deviceId: event.deviceId,
        properties: event.properties,
      );
    } catch (e) {
      emit(
        state.copyWith(
          controlError: e is MqttSmartHomeClientException
              ? e.message
              : 'Something is wrong',
        ),
      );
    }
  }

  void _onLightEditModeChanged(
    LightEditModeChangedEvent event,
    Emitter<LightState> emit,
  ) {
    emit(state.copyWith(editMode: event.editMode));
  }

  @override
  Future<void> close() {
    super.close();
    return _lightsRepository.dispose();
  }
}
