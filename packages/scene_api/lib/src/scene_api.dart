import 'dart:convert';

import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

import 'models/models.dart';

class SceneApi {
  SceneApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Scene>> fetchHomeScenes({
    required String homeId,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/scene',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    final scenes = (body as List<dynamic>)
        .map((scene) => Scene.fromJson(scene as Map<String, dynamic>))
        .toList();
    return scenes;
  }

  Future<Scene> createNewScene({
    required String homeId,
    required String name,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpPost(
      path: '/home/$homeId/scene',
      body: jsonEncode(SceneDto(name: name).toJson()),
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: "Empty body");
    }
    return Scene.fromJson(body as Map<String, dynamic>);
  }

  Future<void> changeSceneName({
    required String homeId,
    required String sceneId,
    required String name,
    required String accessToken,
  }) async {
    await _smartHomeApiClient.httpPut(
      path: '/home/$homeId/scene/$sceneId',
      body: jsonEncode(SceneDto(name: name).toJson()),
      accessToken: accessToken,
    );
  }

  Future<void> deleteScene(
      {required String homeId,
      required String sceneId,
      required String accessToken}) async {
    await _smartHomeApiClient.httpDelete(
      path: '/home/$homeId/scene/$sceneId',
      body: '',
      accessToken: accessToken,
    );
  }
}
