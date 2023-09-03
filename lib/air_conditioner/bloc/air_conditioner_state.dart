part of 'air_conditioner_bloc.dart';

enum AirConditionerStatus {
  initial,
  loading,
  success,
  failure,
}

class AirConditionerState extends Equatable {
  const AirConditionerState({
    required this.home,
    required this.room,
    this.devices = const [],
    this.status = AirConditionerStatus.initial,
    this.serverStatus = MqttClientConnectionStatus.initial,
    this.processorStatus = ProcessorConnectionStatus.initial,
    this.requestError = '',
    this.controlError = '',
    this.editMode = false,
  });

  final SmartHome home;
  final Room room;
  final List<AirConditioner> devices;
  final AirConditionerStatus status;
  final String requestError;
  final String controlError;
  final bool editMode;
  final MqttClientConnectionStatus serverStatus;
  final ProcessorConnectionStatus processorStatus;

  AirConditionerState copyWith({
    SmartHome? home,
    Room? room,
    List<AirConditioner>? devices,
    AirConditionerStatus? status,
    String? requestError,
    String? controlError,
    bool? editMode,
    MqttClientConnectionStatus? serverStatus,
    ProcessorConnectionStatus? processorStatus,
  }) {
    return AirConditionerState(
      home: home ?? this.home,
      room: room ?? this.room,
      devices: devices ?? this.devices,
      status: status ?? this.status,
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
        devices,
        requestError,
        controlError,
        editMode,
        serverStatus,
        processorStatus,
      ];
}
