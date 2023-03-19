part of 'rooms_cubit.dart';

enum RoomsStatus { initial, loading, success, failure }

class RoomsState extends Equatable {
  const RoomsState({
    required this.home,
    this.floors = const [],
    this.status = RoomsStatus.initial,
    this.selectedFloorId = all,
    this.requestError = '',
  });

  static const String all = 'all';
  static const String favorite = 'favorite';

  final RoomsStatus status;
  final SmartHome home;
  final List<Floor> floors;
  final String selectedFloorId;
  final String requestError;

  Iterable<Room> get favoriteRooms => floors
      .map((floor) => floor.rooms)
      .expand((floorRooms) => floorRooms)
      .where((room) => room.isFavorite);

  RoomsState copyWith({
    List<Floor>? floors,
    RoomsStatus? status,
    String? selectedFloorId,
    String? requestError,
  }) {
    return RoomsState(
      home: home,
      floors: floors ?? this.floors,
      status: status ?? this.status,
      selectedFloorId: selectedFloorId ?? this.selectedFloorId,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props =>
      [home, status, floors, favoriteRooms, selectedFloorId];
}
