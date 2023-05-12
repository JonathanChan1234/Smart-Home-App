part of 'light_edit_bloc.dart';

abstract class LightEditEvent extends Equatable {
  const LightEditEvent();

  @override
  List<Object> get props => [];
}

class LightEditNameChangedEvent extends LightEditEvent {
  const LightEditNameChangedEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class LightEditSubmittedEvent extends LightEditEvent {
  const LightEditSubmittedEvent();
}
