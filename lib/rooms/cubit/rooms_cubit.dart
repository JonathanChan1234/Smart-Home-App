import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_home/rooms/models/model.dart';

part 'rooms_state.dart';

const rooms = [
  Room(
    name: 'Bedroom 1',
    numberOfDevices: 2,
    floor: 'First Floor',
    isFavorite: true,
  ),
  Room(name: 'Bedroom 2', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 3', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 4', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 5', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 6', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 7', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 8', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Bedroom 9', numberOfDevices: 3, floor: 'Second Floor'),
  Room(name: 'Living Room', numberOfDevices: 3, floor: 'Ground Floor'),
  Room(name: 'Dining Room', numberOfDevices: 3, floor: 'Ground Floor'),
  Room(
    name: 'Master Bedroom',
    numberOfDevices: 3,
    floor: 'Second Floor',
  ),
  Room(name: 'Gym Room', numberOfDevices: 3, floor: 'Second Floor'),
];

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(const RoomsState());

  Future<void> getAllRooms() async {
    emit(state.copyWith(status: RoomsStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    emit(
      state.copyWith(
        status: RoomsStatus.success,
        rooms: rooms,
        floors: Set<String>.from(rooms.map((room) => room.floor)).toList(),
      ),
    );
  }

  void setSelectedFloor(String floor) {
    emit(state.copyWith(selectedFloor: floor));
  }
}
