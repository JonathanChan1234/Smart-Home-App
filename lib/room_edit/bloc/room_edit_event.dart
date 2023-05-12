part of 'room_edit_bloc.dart';

abstract class RoomEditEvent extends Equatable {
  const RoomEditEvent();

  @override
  List<Object> get props => [];
}

class RoomEditNameChangedEvent extends RoomEditEvent {
  const RoomEditNameChangedEvent({required this.name});
  final String name;

  @override
  List<Object> get props => [];
}

class RoomEditSubmittedEvent extends RoomEditEvent {
  const RoomEditSubmittedEvent();
}
