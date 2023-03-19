import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:room_api/src/models/models.dart';
import 'package:room_api/src/models/update_room_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class RoomApiNotReachableException implements Exception {}

class RoomApi {
  RoomApi({
    required AuthRepository authRepository,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient;

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Floor>> fetchHomeFloors(String homeId) async {
    final response = await _smartHomeApiClient.httpGet(
        path: '/home/$homeId/floor',
        accessToken: (await _authRepository.getAuthToken())?.accessToken);
    final data = response.data;
    if (data == null) {
      throw RoomApiNotReachableException();
    }
    final floors = (data as List<dynamic>)
        .map((floor) => Floor.fromJson(floor as Map<String, dynamic>))
        .toList();
    return floors;
  }

  Future<void> updateRoom(String homeId, String floorId, String roomId,
      String roomName, bool isFavorite) async {
    await _smartHomeApiClient.httpPut(
        path: '/home/$homeId/floor/$floorId/room/$roomId',
        body: jsonEncode(
            UpdateRoomDto(name: roomName, isFavorite: isFavorite).toJson()),
        accessToken: (await _authRepository.getAuthToken())?.accessToken);
  }
}
