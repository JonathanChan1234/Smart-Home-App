import 'dart:convert';

import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

import 'models/models.dart';

class ShadesApi {
  ShadesApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Shade>> fetchShadesInRoom({
    required String homeId,
    required String roomId,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/shade?roomId=$roomId',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    final shades = (body as List<dynamic>)
        .map((shade) => Shade.fromJson(shade as Map<String, dynamic>))
        .toList();
    return shades;
  }

  Future<void> updateShadeName({
    required String homeId,
    required String shadeId,
    required String name,
    required String accessToken,
  }) async {
    await _smartHomeApiClient.httpPut(
      path: '/home/$homeId/device/$shadeId',
      body: jsonEncode(UpdateShadeDto(name: name).toJson()),
      accessToken: accessToken,
    );
  }
}
