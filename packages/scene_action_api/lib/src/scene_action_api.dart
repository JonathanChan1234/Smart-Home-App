import 'dart:convert';

import 'package:scene_action_api/src/models/models.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

extension MainCategoryExtensionX on DeviceMainCategory {
  String get path {
    switch (this) {
      case DeviceMainCategory.light:
        return 'light';
      case DeviceMainCategory.shade:
        return 'shade';
      default:
        return '';
    }
  }
}

class SceneActionApi {
  const SceneActionApi({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<Device>> fetchSceneDevice({
    required String homeId,
    required String sceneId,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/scene/$sceneId/action/devices',
      accessToken: accessToken,
    );
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Data',
      );
    }

    return (data as List<dynamic>)
        .map((device) => Device.fromJson(device))
        .toList();
  }

  Future<List<SceneAction>> fetchSceneActions({
    required String homeId,
    required String sceneId,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/scene/$sceneId/action',
      accessToken: accessToken,
    );
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Data',
      );
    }

    return (data as List<dynamic>)
        .map((action) => SceneAction.fromJson(action))
        .toList();
  }

  Future<SceneAction> createSceneAction<T extends DeviceAction>({
    required String homeId,
    required String sceneId,
    required String accessToken,
    required DeviceMainCategory category,
    required DeviceActionDto<T> dto,
  }) async {
    final response = await _smartHomeApiClient.httpPost(
      path: '/home/$homeId/scene/$sceneId/action/${category.path}',
      body: jsonEncode(dto.toJson()),
      accessToken: accessToken,
    );

    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
        message: 'Empty data',
        code: ErrorCode.emptyBody,
      );
    }
    return SceneAction.fromJson((data as Map<String, dynamic>));
  }

  Future<void> updateSceneAction<T extends DeviceAction>({
    required String homeId,
    required String sceneId,
    required String accessToken,
    required String actionId,
    required DeviceMainCategory category,
    required DeviceActionDto<T> dto,
  }) async {
    await _smartHomeApiClient.httpPut(
      path: '/home/$homeId/scene/$sceneId/action/${category.path}/$actionId',
      body: jsonEncode(dto.toJson()),
      accessToken: accessToken,
    );
  }

  Future<void> deleteSceneAction({
    required String homeId,
    required String sceneId,
    required String accessToken,
    required String actionId,
  }) async {
    await _smartHomeApiClient.httpDelete(
      path: '/home/$homeId/scene/$sceneId/action/$actionId',
      accessToken: accessToken,
    );
  }
}
