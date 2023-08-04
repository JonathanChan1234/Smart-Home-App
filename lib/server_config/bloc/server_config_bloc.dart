import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:smart_home/server_config/models/http_host.dart';
import 'package:smart_home/server_config/models/http_port.dart';
import 'package:smart_home/server_config/models/mqtt_host.dart';
import 'package:smart_home/server_config/models/mqtt_port.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

part 'server_config_event.dart';
part 'server_config_state.dart';

class ServerConfigBloc extends Bloc<ServerConfigEvent, ServerConfigState> {
  ServerConfigBloc({
    required SmartHomeApiClient smartHomeApiClient,
    required MqttSmartHomeClient mqttSmartHomeClient,
  })  : _smartHomeApiClient = smartHomeApiClient,
        _mqttSmartHomeClient = mqttSmartHomeClient,
        super(
          ServerConfigState(
            httpHost: HttpHost.dirty(smartHomeApiClient.getServerHost()),
            httpPort: HttpPort.dirty(smartHomeApiClient.getServerPort()),
            mqttHost: MqttHost.dirty(mqttSmartHomeClient.getServerHost()),
            mqttPort: MqttPort.dirty(mqttSmartHomeClient.getServerPort()),
          ),
        ) {
    on<ServerConfigHttpHostChanged>(_onHttpHostChanged);
    on<ServerConfigHttpPortChanged>(_onHttpPortChanged);
    on<ServerConfigMqttHostChanged>(_onMqttHostChanged);
    on<ServerConfigMqttPortChanged>(_onMqttPortChanged);
    on<ServerConfigSameHostToggled>(_onSameHostToggled);
    on<ServerConfigFormSubmitted>(_onFormSubmitted);
  }

  final SmartHomeApiClient _smartHomeApiClient;
  final MqttSmartHomeClient _mqttSmartHomeClient;

  void _onHttpHostChanged(
    ServerConfigHttpHostChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    final httpHost = HttpHost.dirty(event.httpHost);
    final mqttHost =
        state.sameHost ? MqttHost.dirty(event.httpHost) : state.mqttHost;
    emit(
      state.copyWith(
        httpHost: httpHost,
        mqttHost: mqttHost,
        status: Formz.validate([
          httpHost,
          state.httpPort,
          mqttHost,
          state.mqttPort,
        ]),
      ),
    );
  }

  void _onHttpPortChanged(
    ServerConfigHttpPortChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    final httpPort = HttpPort.dirty(event.httpPort);
    emit(
      state.copyWith(
        httpPort: httpPort,
        status: Formz.validate([
          state.httpHost,
          httpPort,
          state.mqttHost,
          state.mqttPort,
        ]),
      ),
    );
  }

  void _onMqttHostChanged(
    ServerConfigMqttHostChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    final mqttHost = MqttHost.dirty(event.mqttHost);
    emit(
      state.copyWith(
        mqttHost: mqttHost,
        status: Formz.validate([
          state.httpHost,
          state.httpPort,
          mqttHost,
          state.mqttPort,
        ]),
      ),
    );
  }

  void _onMqttPortChanged(
    ServerConfigMqttPortChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    final mqttPort = MqttPort.dirty(event.mqttPort);
    emit(
      state.copyWith(
        mqttPort: mqttPort,
        status: Formz.validate([
          state.httpHost,
          state.httpPort,
          state.mqttHost,
          mqttPort,
        ]),
      ),
    );
  }

  void _onSameHostToggled(
    ServerConfigSameHostToggled event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(
      state.copyWith(
        sameHost: event.sameHost,
        mqttHost: event.sameHost
            ? MqttHost.dirty(state.httpHost.value)
            : state.mqttHost,
        status: Formz.validate([
          state.httpHost,
          state.httpPort,
          state.mqttHost,
          state.mqttPort,
        ]),
      ),
    );
  }

  Future<void> _onFormSubmitted(
    ServerConfigFormSubmitted event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _smartHomeApiClient.setServerHost(
        host: state.httpHost.value,
        port: state.httpPort.value,
      );
      await _mqttSmartHomeClient.setServerConfig(
        state.mqttHost.value,
        state.mqttPort.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      state.copyWith(
        status: FormzStatus.submissionFailure,
        requestError: e.toString(),
      );
    }
  }
}
