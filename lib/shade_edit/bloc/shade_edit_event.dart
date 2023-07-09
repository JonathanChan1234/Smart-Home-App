part of 'shade_edit_bloc.dart';

abstract class ShadeEditEvent extends Equatable {
  const ShadeEditEvent();

  @override
  List<Object> get props => [];
}

class ShadeEditNameChangedEvent extends ShadeEditEvent {
  const ShadeEditNameChangedEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class ShadeEditSubmittedEvent extends ShadeEditEvent {
  const ShadeEditSubmittedEvent();
}
