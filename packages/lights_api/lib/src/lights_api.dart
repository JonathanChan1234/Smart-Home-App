import 'dart:convert';

import 'package:lights_api/src/models/update_light_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

import 'models/models.dart';

class LightsApi {
  LightsApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Light>> fetchLightsInRoom(
      {required String homeId,
      required String roomId,
      required String accessToken}) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/light?roomId=$roomId',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    final lights = (body as List<dynamic>)
        .map((light) => Light.fromJson(light as Map<String, dynamic>))
        .toList();
    return lights;
  }

  Future<void> updateLightName({
    required String homeId,
    required String lightId,
    required String name,
    required String accessToken,
  }) async {
    await _smartHomeApiClient.httpPut(
      path: '/home/$homeId/device/$lightId',
      body: jsonEncode(UpdateLightDto(name: name).toJson()),
      accessToken: accessToken,
    );
  }
}
