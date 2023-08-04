import 'dart:convert';

import 'package:room_api/src/models/models.dart';
import 'package:room_api/src/models/update_room_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class RoomApi {
  RoomApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Floor>> fetchHomeFloors(String homeId, String accessToken) async {
    final response = await _smartHomeApiClient.httpGet(
        path: '/home/$homeId/floor', accessToken: accessToken);
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    final floors = (data as List<dynamic>)
        .map((floor) => Floor.fromJson(floor as Map<String, dynamic>))
        .toList();
    return floors;
  }

  Future<void> updateRoom({
    required String homeId,
    required Room room,
    required String accessToken,
  }) async {
    await _smartHomeApiClient.httpPut(
        path: '/home/$homeId/floor/${room.floorId}/room/${room.id}',
        body: jsonEncode(UpdateRoomDto(
          name: room.name,
          isFavorite: room.isFavorite,
        ).toJson()),
        accessToken: accessToken);
  }
}
