part of 'home_delete_bloc.dart';

abstract class HomeDeleteEvent extends Equatable {
  const HomeDeleteEvent();

  @override
  List<Object> get props => [];
}

class HomeDeleteHomeSubscriptionRequestedEvent extends HomeDeleteEvent {
  const HomeDeleteHomeSubscriptionRequestedEvent();
}

class HomeDeleteHomeRefreshEvent extends HomeDeleteEvent {
  const HomeDeleteHomeRefreshEvent();
}

class HomeDeleteHomeDeletedEvent extends HomeDeleteEvent {
  const HomeDeleteHomeDeletedEvent({required this.home});

  final SmartHome home;

  @override
  List<Object> get props => [home];
}
