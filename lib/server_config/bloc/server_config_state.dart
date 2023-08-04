part of 'server_config_bloc.dart';

class ServerConfigState extends Equatable {
  const ServerConfigState({
    this.status = FormzStatus.pure,
    required this.httpHost,
    required this.httpPort,
    required this.mqttHost,
    required this.mqttPort,
    this.sameHost = false,
    this.requestError = '',
  });

  final FormzStatus status;
  final HttpHost httpHost;
  final HttpPort httpPort;
  final MqttHost mqttHost;
  final MqttPort mqttPort;
  final bool sameHost;
  final String requestError;

  ServerConfigState copyWith({
    FormzStatus? status,
    HttpHost? httpHost,
    HttpPort? httpPort,
    MqttHost? mqttHost,
    MqttPort? mqttPort,
    bool? sameHost,
    String? requestError,
  }) {
    return ServerConfigState(
      status: status ?? this.status,
      httpHost: httpHost ?? this.httpHost,
      httpPort: httpPort ?? this.httpPort,
      mqttHost: mqttHost ?? this.mqttHost,
      mqttPort: mqttPort ?? this.mqttPort,
      sameHost: sameHost ?? this.sameHost,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [
        status,
        httpHost,
        httpPort,
        mqttPort,
        sameHost,
        requestError,
      ];
}
