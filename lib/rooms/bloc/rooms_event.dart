part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object?> get props => [];
}

class RoomSubscriptionRequestEvent extends RoomsEvent {
  const RoomSubscriptionRequestEvent();
}

class RoomListInitEvent extends RoomsEvent {
  const RoomListInitEvent();
}

class RoomUpdatedEvent extends RoomsEvent {
  const RoomUpdatedEvent({
    required this.room,
    this.name,
    this.isFavorite,
  });

  final Room room;
  final String? name;
  final bool? isFavorite;

  @override
  List<Object?> get props => [room, name, isFavorite];
}

class RoomFilterUpdatedEvent extends RoomsEvent {
  const RoomFilterUpdatedEvent({
    this.floor,
  });

  final Floor? floor;

  @override
  List<Object?> get props => [floor];
}

class RoomSetFavoriteFilterEvent extends RoomsEvent {
  const RoomSetFavoriteFilterEvent();
}
