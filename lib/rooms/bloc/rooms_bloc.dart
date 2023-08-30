import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomsBloc({
    required SmartHome home,
    required RoomRepository roomRepository,
  })  : _roomRepository = roomRepository,
        super(RoomsState(home: home)) {
    on<RoomSubscriptionRequestEvent>(_onRoomSubscriptionRequest);
    on<RoomListInitEvent>(_onRoomListInit);
    on<RoomUpdatedEvent>(_onRoomUpdated);
    on<RoomFilterUpdatedEvent>(_onRoomFilterUpdated);
    on<RoomSetFavoriteFilterEvent>(_onRoomSetFavoriteFilter);
  }

  final RoomRepository _roomRepository;

  Future<void> _onRoomSubscriptionRequest(
    RoomSubscriptionRequestEvent event,
    Emitter<RoomsState> emit,
  ) async {
    emit(state.copyWith(status: () => RoomsStatus.loading));
    await emit.forEach<List<Floor>>(
      _roomRepository.floors,
      onData: (floors) => state.copyWith(
        status: () => RoomsStatus.success,
        floors: () => floors,
        requestError: () => '',
      ),
      onError: (error, __) => state.copyWith(
        status: () => RoomsStatus.failure,
        requestError: () => error is SmartHomeException
            ? error.message ?? 'Something is wrong'
            : 'Something is wrong',
      ),
    );
  }

  Future<void> _onRoomListInit(
    RoomListInitEvent event,
    Emitter<RoomsState> emit,
  ) async {
    emit(state.copyWith(status: () => RoomsStatus.loading));
    await _roomRepository.initFloorList(state.home.id);
  }

  Future<void> _onRoomUpdated(
    RoomUpdatedEvent event,
    Emitter<RoomsState> emit,
  ) async {
    emit(state.copyWith(status: () => RoomsStatus.loading));
    await _roomRepository.updateRoom(
      state.home.id,
      Room(
        floorId: event.room.floorId,
        id: event.room.id,
        name: event.name ?? event.room.name,
        isFavorite: event.isFavorite ?? event.room.isFavorite,
      ),
    );
  }

  void _onRoomFilterUpdated(
    RoomFilterUpdatedEvent event,
    Emitter<RoomsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedFloor: () => event.floor,
        isFavorite: () => false,
      ),
    );
  }

  void _onRoomSetFavoriteFilter(
    RoomSetFavoriteFilterEvent event,
    Emitter<RoomsState> emit,
  ) {
    emit(
      state.copyWith(
        isFavorite: () => true,
        selectedFloor: () => null,
      ),
    );
  }
}
