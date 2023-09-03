part of 'air_conditioner_edit_bloc.dart';

class AirConditionerEditEvent extends Equatable {
  const AirConditionerEditEvent();

  @override
  List<Object> get props => [];
}

class AirConditionerEditNameChangedEvent extends AirConditionerEditEvent {
  const AirConditionerEditNameChangedEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class AirConditionerEditFormSubmitEvent extends AirConditionerEditEvent {
  const AirConditionerEditFormSubmitEvent();
}
