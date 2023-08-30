import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';

part 'smart_home_connect_event.dart';
part 'smart_home_connect_state.dart';

class SmartHomeConnectBloc
    extends Bloc<SmartHomeConnectEvent, SmartHomeConnectState> {
  SmartHomeConnectBloc({
    required HomeRepository homeRepository,
    required SmartHome home,
  })  : _homeRepository = homeRepository,
        super(
          SmartHomeConnectState(home: home),
        ) {
    on<SmartHomeConnectRequestEvent>(_onSmartHomeConnectRequest);
    on<SmartHomeConnectProcessorStatusSubscriptionRequestEvent>(
      _onSmartHomeProcessorStatusRequest,
    );
    on<SmartHomeConnectProcessStatusRefreshEvent>(
      _onSmartHomeProcessorStatusRefresh,
    );
  }

  final HomeRepository _homeRepository;

  Future<void> _onSmartHomeConnectRequest(
    SmartHomeConnectRequestEvent event,
    Emitter<SmartHomeConnectState> emit,
  ) async {
    emit(
      state.copyWith(
        serverConnectStatus: SmartHomeServerConnectStatus.connecting,
      ),
    );
    try {
      await _homeRepository.initMqttServerConnection(state.home.id);
      await emit.forEach(
        _homeRepository.serverConnectStatus,
        onData: (status) {
          switch (status) {
            case MqttClientConnectionStatus.connecting:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.connecting,
              );
            case MqttClientConnectionStatus.connected:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.connected,
                connectionError: '',
              );
            case MqttClientConnectionStatus.disconnected:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.disconnected,
              );
            case MqttClientConnectionStatus.failure:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.failure,
              );
            case MqttClientConnectionStatus.initial:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.initial,
              );
            case MqttClientConnectionStatus.reconnecting:
              return state.copyWith(
                serverConnectStatus: SmartHomeServerConnectStatus.reconnecting,
              );
          }
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          serverConnectStatus: SmartHomeServerConnectStatus.failure,
          connectionError: error is MqttSmartHomeClientException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }

  Future<void> _onSmartHomeProcessorStatusRequest(
    SmartHomeConnectProcessorStatusSubscriptionRequestEvent event,
    Emitter<SmartHomeConnectState> emit,
  ) async {
    _homeRepository.initProcessorStatusSubscription(homeId: state.home.id);
    await emit.forEach(
      _homeRepository.processorConnectStatus,
      onData: (status) => state.copyWith(processorConnectStatus: status),
      onError: (error, _) => state.copyWith(
        processorConnectStatus: ProcessorConnectionStatus.failure,
        connectionError: error.toString(),
      ),
    );
  }

  Future<void> _onSmartHomeProcessorStatusRefresh(
    SmartHomeConnectProcessStatusRefreshEvent event,
    Emitter<SmartHomeConnectState> emit,
  ) async {
    try {
      state.copyWith(processorConnectStatus: ProcessorConnectionStatus.loading);
      final processor =
          await _homeRepository.getHomeProcessor(homeId: state.home.id);
      if (processor == null) {
        emit(
          state.copyWith(
            processorConnectStatus: ProcessorConnectionStatus.notExist,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          processorConnectStatus: processor.onlineStatus
              ? ProcessorConnectionStatus.online
              : ProcessorConnectionStatus.offline,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          processorConnectStatus: ProcessorConnectionStatus.failure,
          connectionError: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    super.close();
    return _homeRepository.disconnectFromServer();
  }
}
