part of 'smart_home_bloc.dart';

abstract class SmartHomeEvent extends Equatable {
  const SmartHomeEvent();
  @override
  List<Object> get props => [];
}

class FetchSmartHomeEvent extends SmartHomeEvent {
  const FetchSmartHomeEvent();
}

class RefreshSmartHomeEvent extends SmartHomeEvent {
  const RefreshSmartHomeEvent();
}
