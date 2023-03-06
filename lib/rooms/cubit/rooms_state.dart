part of 'rooms_cubit.dart';

enum RoomsStatus { initial, loading, success, failure }

class RoomsState extends Equatable {
  const RoomsState({
    this.rooms = const [],
    this.floors = const [],
    this.status = RoomsStatus.initial,
    this.selectedFloor = all,
  });

  static const String all = 'all';
  static const String favorite = 'favorite';

  final List<Room> rooms;
  final RoomsStatus status;
  final String selectedFloor;
  final List<String> floors;

  Iterable<Room> get filteredRooms => rooms.where((room) {
        switch (selectedFloor) {
          case RoomsState.all:
            return true;
          case RoomsState.favorite:
            return room.isFavorite;
          default:
            return room.floor == selectedFloor;
        }
      });

  RoomsState copyWith({
    List<Room>? rooms,
    List<String>? floors,
    RoomsStatus? status,
    String? selectedFloor,
  }) {
    return RoomsState(
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
      floors: floors ?? this.floors,
      selectedFloor: selectedFloor ?? this.selectedFloor,
    );
  }

  @override
  List<Object> get props => [rooms, status, selectedFloor];
}
