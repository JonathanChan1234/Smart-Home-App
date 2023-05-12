part of 'devices_bloc.dart';

enum DevicesStatus { initial, loading, success, failure }

class DevicesState extends Equatable {
  const DevicesState({
    required this.home,
    required this.room,
    this.devices = const [],
    this.status = DevicesStatus.initial,
    this.requestError = '',
  });

  final SmartHome home;
  final Room room;
  final List<SmartHomeDevice> devices;
  final DevicesStatus status;
  final String requestError;

  DevicesState copyWith({
    List<SmartHomeDevice>? devices,
    DevicesStatus? status,
    String? requestError,
  }) {
    return DevicesState(
      home: home,
      room: room,
      devices: devices ?? this.devices,
      status: status ?? this.status,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [home, room, devices, status, requestError];
}
