part of 'home_cubit.dart';

enum HomeTabs { rooms, scenes, settings }

class HomeState extends Equatable {
  const HomeState({this.currentTab = HomeTabs.rooms});

  final HomeTabs currentTab;

  @override
  List<Object> get props => [currentTab];
}
