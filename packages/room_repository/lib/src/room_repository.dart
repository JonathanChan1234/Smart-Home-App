import 'package:auth_repository/auth_repository.dart';
import 'package:room_api/room_api.dart';
import 'package:rxdart/rxdart.dart';

class RoomRepository {
  RoomRepository({
    required AuthRepository authRepository,
    required RoomApi roomApi,
  })  : _authRepository = authRepository,
        _roomApi = roomApi;

  final AuthRepository _authRepository;
  final RoomApi _roomApi;

  final _floorControllers = BehaviorSubject<List<Floor>>.seeded(const []);

  Stream<List<Floor>> get floors => _floorControllers.asBroadcastStream();

  Future<void> initFloorList(String homeId) async {
    try {
      final authToken = await _authRepository.getAuthToken();
      if (authToken == null) {
        _floorControllers.addError('unauthenticated');
        return;
      }
      final floors =
          await _roomApi.fetchHomeFloors(homeId, authToken.accessToken);
      _floorControllers.add(floors);
    } catch (e) {
      _floorControllers
          .addError(e is RoomApiException ? e.message : 'Something is wrong');
    }
  }

  Future<void> updateRoom(String homeId, Room room) async {
    final authToken = await _authRepository.getAuthToken();
    if (authToken == null) {
      throw const RoomApiException(message: 'invalid token');
    }

    await _roomApi.updateRoom(
      homeId: homeId,
      room: room,
      accessToken: authToken.accessToken,
    );

    final floors = [..._floorControllers.value];
    var floorIndex = floors.indexWhere((floor) => floor.id == room.floorId);
    if (floorIndex == -1) {
      _floorControllers.addError('Fail to find floor ${room.floorId}');
      return;
    }

    var roomIndex = floors[floorIndex].rooms.indexWhere((r) => r.id == room.id);
    if (roomIndex == -1) {
      _floorControllers.addError('Fail to find room ${room.id}');
      return;
    }
    final rooms = [...floors[floorIndex].rooms];
    rooms[roomIndex] = room;
    final newFloor = floors[floorIndex].copyWith(rooms: rooms);
    floors[floorIndex] = newFloor;

    _floorControllers.add(floors);
  }

  Future<void> dispose() {
    return _floorControllers.close();
  }
}
