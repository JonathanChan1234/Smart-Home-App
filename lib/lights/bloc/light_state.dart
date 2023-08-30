part of 'light_bloc.dart';

enum LightStatus { initial, loading, success, failure }

class LightState extends Equatable {
  const LightState({
    required this.home,
    required this.room,
    this.status = LightStatus.initial,
    this.lights = const [],
    this.requestError = '',
    this.controlError = '',
    this.editMode = false,
    this.serverStatus = MqttClientConnectionStatus.initial,
    this.processorStatus = ProcessorConnectionStatus.initial,
  });

  final SmartHome home;
  final Room room;
  final List<Light> lights;
  final LightStatus status;

  // MQTT server connection status/processor status
  final MqttClientConnectionStatus serverStatus;
  final ProcessorConnectionStatus processorStatus;

  final String requestError;
  final String controlError;
  final bool editMode;

  LightState copyWith({
    LightStatus? status,
    List<Light>? lights,
    MqttClientConnectionStatus? serverStatus,
    ProcessorConnectionStatus? processorStatus,
    String? requestError,
    String? controlError,
    bool? editMode,
  }) {
    return LightState(
      home: home,
      room: room,
      status: status ?? this.status,
      lights: lights ?? this.lights,
      requestError: requestError ?? this.requestError,
      controlError: controlError ?? this.controlError,
      editMode: editMode ?? this.editMode,
      serverStatus: serverStatus ?? this.serverStatus,
      processorStatus: processorStatus ?? this.processorStatus,
    );
  }

  @override
  List<Object> get props => [
        home,
        room,
        status,
        lights,
        requestError,
        controlError,
        editMode,
        serverStatus,
        processorStatus,
      ];
}
