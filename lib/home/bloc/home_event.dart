part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeSelectedEvent extends HomeEvent {
  const HomeSelectedEvent({required this.home});

  final SmartHome home;

  @override
  List<Object?> get props => [home];
}

class HomeDeselectedEvent extends HomeEvent {
  const HomeDeselectedEvent();
}
