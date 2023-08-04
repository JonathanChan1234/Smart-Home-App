import 'package:auth_repository/auth_repository.dart';
import 'package:room_api/room_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

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

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication,
          message: 'access token does not exist');
    }
    return token.accessToken;
  }

  Future<void> initFloorList(String homeId) async {
    try {
      final floors =
          await _roomApi.fetchHomeFloors(homeId, (await _getAccessToken()));
      _floorControllers.add(floors);
    } catch (e) {
      _floorControllers.addError(e);
    }
  }

  Future<void> updateRoom(String homeId, Room room) async {
    await _roomApi.updateRoom(
      homeId: homeId,
      room: room,
      accessToken: (await _getAccessToken()),
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
