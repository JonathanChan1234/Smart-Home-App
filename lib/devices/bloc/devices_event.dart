part of 'devices_bloc.dart';

abstract class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

class FetchDeviceListEvent extends DevicesEvent {}

class DeviceMqttStatusSubscriptionEvent extends DevicesEvent {}
