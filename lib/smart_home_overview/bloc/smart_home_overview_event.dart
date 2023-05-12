part of 'smart_home_overview_bloc.dart';

abstract class SmartHomeOverviewEvent extends Equatable {
  const SmartHomeOverviewEvent();
  @override
  List<Object> get props => [];
}

class SmartHomeOverviewTabChangedEvent extends SmartHomeOverviewEvent {
  const SmartHomeOverviewTabChangedEvent({required this.tab});

  final SmartHomeTab tab;

  @override
  List<Object> get props => [tab];
}

class SmartHomeOverviewSubscriptionRequestEvent extends SmartHomeOverviewEvent {
  const SmartHomeOverviewSubscriptionRequestEvent();
}

class SmartHomeOverviewFetchEvent extends SmartHomeOverviewEvent {
  const SmartHomeOverviewFetchEvent();
}
