import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:room_api/room_api.dart' hide Room, Floor;
import 'package:smart_home/rooms/models/floor.dart';
import 'package:smart_home/rooms/models/room.dart';
import 'package:smart_home/smart_home/models/smart_home.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit({
    required SmartHome home,
    required RoomApi roomApi,
  })  : _roomApi = roomApi,
        super(RoomsState(home: home));

  final RoomApi _roomApi;

  Future<void> getAllRooms() async {
    emit(state.copyWith(status: RoomsStatus.loading));
    try {
      final floors = await _roomApi.fetchHomeFloors(state.home.id);
      emit(
        state.copyWith(
          status: RoomsStatus.success,
          floors: floors.map(Floor.fromRepository).toList(),
          selectedFloorId: RoomsState.all,
          requestError: '',
        ),
      );
    } on RoomApiNotReachableException {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: 'Fail to reach the room api server',
        ),
      );
    } on HttpNotFoundException catch (e) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: e.message,
        ),
      );
    } on HttpBadRequestException catch (e) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: 'Something is wrong',
        ),
      );
    }
  }

  Future<void> updateRoom(Room room, {String? name, bool? isFavorite}) async {
    emit(state.copyWith(status: RoomsStatus.loading));
    try {
      await _roomApi.updateRoom(
        state.home.id,
        room.floorId,
        room.id,
        name ?? room.name,
        isFavorite ?? room.isFavorite,
      );
      for (final floor in state.floors) {
        if (floor.id == room.floorId) {
          for (var i = 0; i < floor.rooms.length; ++i) {
            if (floor.rooms[i].id == room.id) {
              floor.rooms[i] = Room(
                id: room.id,
                name: name ?? room.name,
                isFavorite: isFavorite ?? room.isFavorite,
                floorId: room.floorId,
              );
            }
          }
        }
      }
      emit(
        state.copyWith(
          status: RoomsStatus.success,
          floors: state.floors,
          requestError: '',
        ),
      );
    } on HttpNotFoundException catch (e) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: e.message,
        ),
      );
    } on HttpBadRequestException catch (e) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: RoomsStatus.failure,
          requestError: 'Something is wrong.',
        ),
      );
    }
  }

  void setSelectedFloor(String floorId) {
    emit(state.copyWith(selectedFloorId: floorId));
  }
}
