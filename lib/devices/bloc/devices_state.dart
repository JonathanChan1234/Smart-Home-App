part of 'devices_bloc.dart';

enum DevicesStatus { initial, loading, success, failure }

class DevicesState extends Equatable {
  const DevicesState({
    required this.home,
    required this.room,
    this.deviceCount = const [],
    this.status = DevicesStatus.initial,
    this.serverStatus = MqttClientConnectionStatus.initial,
    this.requestError = '',
  });

  final SmartHome home;
  final Room room;
  final List<DeviceCount> deviceCount;
  final DevicesStatus status;
  final MqttClientConnectionStatus serverStatus;
  final String requestError;

  DevicesState copyWith({
    List<DeviceCount>? deviceCount,
    DevicesStatus? status,
    MqttClientConnectionStatus? serverStatus,
    String? requestError,
  }) {
    return DevicesState(
      home: home,
      room: room,
      deviceCount: deviceCount ?? this.deviceCount,
      serverStatus: serverStatus ?? this.serverStatus,
      status: status ?? this.status,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props =>
      [home, room, deviceCount, status, serverStatus, requestError];
}
