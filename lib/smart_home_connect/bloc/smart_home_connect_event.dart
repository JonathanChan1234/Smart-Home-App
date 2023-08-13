part of 'smart_home_connect_bloc.dart';

abstract class SmartHomeConnectEvent extends Equatable {
  const SmartHomeConnectEvent();

  @override
  List<Object> get props => [];
}

class SmartHomeConnectRequestEvent extends SmartHomeConnectEvent {
  const SmartHomeConnectRequestEvent();
}

class SmartHomeConnectProcessorStatusSubscriptionRequestEvent
    extends SmartHomeConnectEvent {
  const SmartHomeConnectProcessorStatusSubscriptionRequestEvent();
}

class SmartHomeConnectProcessStatusRefreshEvent extends SmartHomeConnectEvent {
  const SmartHomeConnectProcessStatusRefreshEvent();
}
