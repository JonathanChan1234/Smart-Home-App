import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:lights_api/src/models/update_light_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

import 'models/models.dart';

class LightsApiException implements Exception {
  const LightsApiException({this.message});

  final String? message;
}

class LightsApi {
  LightsApi({
    required AuthRepository authRepository,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient;

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Light>> fetchLightsInRoom({
    required String homeId,
    required String roomId,
  }) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw const LightsApiException(message: 'unable to get access token');
    }
    try {
      final response = await _smartHomeApiClient.httpGet(
        path: '/home/$homeId/light?roomId=$roomId',
        accessToken: accessToken,
      );
      final body = response.data;
      if (body == null) throw const LightsApiException(message: 'Empty Body');
      final lights = (body as List<dynamic>)
          .map((light) => Light.fromJson(light as Map<String, dynamic>))
          .toList();
      return lights;
    } catch (error) {
      throw LightsApiException(
          message: error is SmartHomeApiException ? error.message : '');
    }
  }

  Future<void> updateLightName({
    required String homeId,
    required String lightId,
    required String name,
  }) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw const LightsApiException(message: 'unable to get access token');
    }
    try {
      await _smartHomeApiClient.httpPut(
        path: '/home/$homeId/device/$lightId',
        body: jsonEncode(UpdateLightDto(name: name).toJson()),
        accessToken: accessToken,
      );
    } catch (error) {
      throw LightsApiException(
          message: error is SmartHomeApiException
              ? error.message
              : 'Something is wrong');
    }
  }
}
