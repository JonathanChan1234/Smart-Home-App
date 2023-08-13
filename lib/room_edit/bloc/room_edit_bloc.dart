import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'room_edit_event.dart';
part 'room_edit_state.dart';

class RoomEditBloc extends Bloc<RoomEditEvent, RoomEditState> {
  RoomEditBloc({
    required SmartHome home,
    required Room room,
    required RoomRepository roomRepository,
  })  : _roomRepository = roomRepository,
        _home = home,
        super(RoomEditState(room: room, name: room.name)) {
    on<RoomEditNameChangedEvent>(_onRoomEditNameChanged);
    on<RoomEditSubmittedEvent>(_onRoomEditSubmittedEvent);
  }

  final RoomRepository _roomRepository;
  final SmartHome _home;

  void _onRoomEditNameChanged(
    RoomEditNameChangedEvent event,
    Emitter<RoomEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onRoomEditSubmittedEvent(
    RoomEditSubmittedEvent event,
    Emitter<RoomEditState> emit,
  ) async {
    emit(state.copyWith(status: RoomEditStatus.loading));
    try {
      final room = state.room.copyWith(name: state.name);
      await _roomRepository.updateRoom(_home.id, room);
      emit(
        state.copyWith(
          status: RoomEditStatus.success,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RoomEditStatus.failure,
          requestError:
              e is SmartHomeException ? e.message : 'Something is wrong',
        ),
      );
    }
  }
}
