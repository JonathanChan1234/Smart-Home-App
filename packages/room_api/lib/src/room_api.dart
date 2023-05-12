import 'dart:convert';

import 'package:room_api/src/models/models.dart';
import 'package:room_api/src/models/update_room_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class RoomApiException implements Exception {
  const RoomApiException({required this.message});
  final String message;
}

class RoomApi {
  RoomApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Floor>> fetchHomeFloors(String homeId, String accessToken) async {
    try {
      final response = await _smartHomeApiClient.httpGet(
          path: '/home/$homeId/floor', accessToken: accessToken);
      final data = response.data;
      if (data == null) {
        throw const RoomApiException(message: 'Empty Body');
      }
      final floors = (data as List<dynamic>)
          .map((floor) => Floor.fromJson(floor as Map<String, dynamic>))
          .toList();
      return floors;
    } on SmartHomeApiException catch (e) {
      throw RoomApiException(message: e.message ?? 'Something is wrong');
    } catch (e) {
      throw const RoomApiException(message: 'Something is wrong');
    }
  }

  Future<void> updateRoom({
    required String homeId,
    required Room room,
    required String accessToken,
  }) async {
    try {
      await _smartHomeApiClient.httpPut(
          path: '/home/$homeId/floor/${room.floorId}/room/${room.id}',
          body: jsonEncode(UpdateRoomDto(
            name: room.name,
            isFavorite: room.isFavorite,
          ).toJson()),
          accessToken: accessToken);
    } on SmartHomeApiException catch (e) {
      throw RoomApiException(message: e.message ?? 'Something is wrong');
    } catch (e) {
      throw const RoomApiException(message: 'Something is wrong');
    }
  }
}
