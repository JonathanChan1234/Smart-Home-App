import 'dart:async';
import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/src/models/light_payload.dart';
import 'package:lights_repository/src/models/light_status.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class LightsRepository {
  LightsRepository({
    required AuthRepository authRepository,
    required LightsApi lightsApi,
    required MqttSmartHomeClient mqttClient,
  })  : _authRepository = authRepository,
        _lightsApi = lightsApi,
        _mqttClient = mqttClient;

  final AuthRepository _authRepository;
  final LightsApi _lightsApi;
  final MqttSmartHomeClient _mqttClient;

  final _lightsStreamController = BehaviorSubject<List<Light>>.seeded(const []);

  StreamSubscription? _messageSubscription;

  Stream<List<Light>> get lights => _lightsStreamController.asBroadcastStream();

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication,
          message: 'access token does not exist');
    }
    return token.accessToken;
  }

  void initLightStatusSubscription({
    required String homeId,
  }) {
    final topicFilter =
        RegExp(r'^home\/' + homeId + r'\/device\/light\/([^\/]+)\/status$');
    _messageSubscription = _mqttClient.message
        .map((message) {
          final firstMatch = topicFilter.firstMatch(message.topic);
          final deviceId = firstMatch?.group(1) ?? '';
          final payload = LightPayload.fromJson(jsonDecode(message.message));
          return LightStatus(deviceId: deviceId, payload: payload);
        })
        .where((status) => status.deviceId != '')
        .listen(_onLightStatusChanged);
  }

  Future<void> fetchLightsInRoom({
    required String homeId,
    required String roomId,
  }) async {
    try {
      final lights = await _lightsApi.fetchLightsInRoom(
          homeId: homeId,
          roomId: roomId,
          accessToken: (await _getAccessToken()));
      _lightsStreamController.add(lights);
    } catch (error) {
      _lightsStreamController.addError(error);
    }
  }

  void updateLightStatus({
    required String homeId,
    required String deviceId,
    required LightProperties properties,
  }) {
    final topic = 'home/$homeId/device/light/$deviceId/control';
    final payload = LightPayload(properties: properties, time: DateTime.now());
    _mqttClient.publish(topic, jsonEncode(payload.toJson()));
  }

  Future<void> updateLightInRoom({
    required String homeId,
    required String lightId,
    required String name,
  }) async {
    await _lightsApi.updateLightName(
      homeId: homeId,
      lightId: lightId,
      name: name,
      accessToken: await _getAccessToken(),
    );

    final lights = [..._lightsStreamController.value];
    final updatedLightIndex = lights.indexWhere((light) => light.id == lightId);
    if (updatedLightIndex == -1) return;

    lights[updatedLightIndex] = lights[updatedLightIndex].copyWith(
      name: name,
    );
    _lightsStreamController.add(lights);
  }

  void _onLightStatusChanged(LightStatus status) {
    final lights = [..._lightsStreamController.value];
    final updatedLightIndex =
        lights.indexWhere((light) => light.id == status.deviceId);
    if (updatedLightIndex == -1) return;

    if (status.payload.time
        .isBefore(lights[updatedLightIndex].statusLastUpdatedAt)) {
      return;
    }

    lights[updatedLightIndex] = lights[updatedLightIndex].copyWith(
      properties: status.payload.properties,
      statusLastUpdatedAt: status.payload.time,
    );
    _lightsStreamController.add(lights);
  }

  /// cancel all the stream subscription and controller
  Future<void> dispose() async {
    if (_messageSubscription != null) {
      await _messageSubscription?.cancel();
    }
    await _lightsStreamController.close();
  }
}
