part of 'server_config_bloc.dart';

abstract class ServerConfigEvent extends Equatable {
  const ServerConfigEvent();

  @override
  List<Object> get props => [];
}

class ServerConfigHttpHostChanged extends ServerConfigEvent {
  const ServerConfigHttpHostChanged({required this.httpHost});

  final String httpHost;

  @override
  List<Object> get props => [httpHost];
}

class ServerConfigHttpPortChanged extends ServerConfigEvent {
  const ServerConfigHttpPortChanged({required this.httpPort});

  final int httpPort;

  @override
  List<Object> get props => [httpPort];
}

class ServerConfigMqttHostChanged extends ServerConfigEvent {
  const ServerConfigMqttHostChanged({required this.mqttHost});

  final String mqttHost;

  @override
  List<Object> get props => [mqttHost];
}

class ServerConfigMqttPortChanged extends ServerConfigEvent {
  const ServerConfigMqttPortChanged({required this.mqttPort});

  final int mqttPort;

  @override
  List<Object> get props => [mqttPort];
}

class ServerConfigSameHostToggled extends ServerConfigEvent {
  const ServerConfigSameHostToggled({required this.sameHost});

  final bool sameHost;

  @override
  List<Object> get props => [sameHost];
}

class ServerConfigFormSubmitted extends ServerConfigEvent {
  const ServerConfigFormSubmitted();
}
