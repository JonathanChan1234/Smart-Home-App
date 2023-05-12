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
          SmartHomeConnectState(
            home: home,
          ),
        ) {
    on<SmartHomeConnectRequestEvent>(_onSmartHomeConnectRequest);
  }

  final HomeRepository _homeRepository;

  Future<void> _onSmartHomeConnectRequest(
    SmartHomeConnectRequestEvent event,
    Emitter<SmartHomeConnectState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SmartHomeConnectStatus.connecting,
      ),
    );
    try {
      await _homeRepository.initMqttServerConnection(state.home.id);
      await emit.forEach(
        _homeRepository.connectionStatus,
        onData: (status) {
          switch (status) {
            case MqttClientConnectionStatus.connecting:
              return state.copyWith(
                status: SmartHomeConnectStatus.connecting,
              );
            case MqttClientConnectionStatus.connected:
              return state.copyWith(
                status: SmartHomeConnectStatus.connected,
                connectionError: '',
              );
            case MqttClientConnectionStatus.disconnected:
              return state.copyWith(
                status: SmartHomeConnectStatus.disconnected,
              );
          }
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SmartHomeConnectStatus.failure,
          connectionError: error is MqttSmartHomeClientException
              ? error.message
              : 'Something is wrong',
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
