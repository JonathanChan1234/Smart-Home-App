import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';

part 'air_conditioner_event.dart';
part 'air_conditioner_state.dart';

class AirConditionerBloc
    extends Bloc<AirConditionerEvent, AirConditionerState> {
  AirConditionerBloc({
    required SmartHome home,
    required Room room,
    required AirConditionerRepository airConditionerRepository,
    required HomeRepository homeRepository,
  })  : _airConditionerRepository = airConditionerRepository,
        _homeRepository = homeRepository,
        super(AirConditionerState(home: home, room: room)) {
    on<AirConditionerMqttStatusSubscriptionRequestEvent>(
      _onAirConditionerMqttStatusSubscriptionRequest,
    );
    on<AirConditionerProcessorStatusSubscriptionRequestEvent>(
      _onAirConditionerProcessorStatusSubscriptionRequest,
    );
    on<AirConditionerStatusSubscriptionRequestEvent>(
      _onAirConditionerStatusSubscriptionRequest,
    );
    on<AirConditionerListInitEvent>(
      _onAirConditionerListInit,
    );
    on<AirConditionerStatusChangedEvent>(
      _onAirConditionerStatusChanged,
    );
    on<AirConditionerEditModeChangedEvent>(
      _onAirConditionerEditModeChanged,
    );
  }

  final AirConditionerRepository _airConditionerRepository;
  final HomeRepository _homeRepository;

  Future<void> _onAirConditionerMqttStatusSubscriptionRequest(
    AirConditionerMqttStatusSubscriptionRequestEvent event,
    Emitter<AirConditionerState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.serverConnectStatus,
      onData: (status) => state.copyWith(serverStatus: status),
    );
  }

  Future<void> _onAirConditionerProcessorStatusSubscriptionRequest(
    AirConditionerProcessorStatusSubscriptionRequestEvent event,
    Emitter<AirConditionerState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.processorConnectStatus,
      onData: (status) => state.copyWith(processorStatus: status),
    );
  }

  Future<void> _onAirConditionerStatusSubscriptionRequest(
    AirConditionerStatusSubscriptionRequestEvent event,
    Emitter<AirConditionerState> emit,
  ) async {
    _airConditionerRepository.initACStatusSubscription(homeId: state.home.id);
    await emit.forEach(
      _airConditionerRepository.devices,
      onData: (devices) => state.copyWith(
        status: AirConditionerStatus.success,
        devices: devices,
      ),
      onError: (error, _) => state.copyWith(
        status: AirConditionerStatus.failure,
        requestError: error.toString(),
      ),
    );
  }

  Future<void> _onAirConditionerListInit(
    AirConditionerListInitEvent event,
    Emitter<AirConditionerState> emit,
  ) {
    emit(state.copyWith(status: AirConditionerStatus.loading));
    return _airConditionerRepository.fetchAcsInRoom(
      homeId: state.home.id,
      roomId: state.room.id,
    );
  }

  void _onAirConditionerStatusChanged(
    AirConditionerStatusChangedEvent event,
    Emitter<AirConditionerState> emit,
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
      _airConditionerRepository.updateAcStatus(
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

  void _onAirConditionerEditModeChanged(
    AirConditionerEditModeChangedEvent event,
    Emitter<AirConditionerState> emit,
  ) {
    emit(state.copyWith(editMode: event.editMode));
  }

  @override
  Future<void> close() async {
    await super.close();
    return _airConditionerRepository.dispose();
  }
}
