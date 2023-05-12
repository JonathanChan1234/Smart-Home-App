part of 'smart_home_connect_bloc.dart';

abstract class SmartHomeConnectEvent extends Equatable {
  const SmartHomeConnectEvent();

  @override
  List<Object> get props => [];
}

class SmartHomeConnectRequestEvent extends SmartHomeConnectEvent {
  const SmartHomeConnectRequestEvent();

  @override
  List<Object> get props => [];
}
