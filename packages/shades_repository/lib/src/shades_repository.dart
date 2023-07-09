import 'dart:async';
import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shades_api/shades_api.dart';

import 'models/models.dart';

class ShadesRepository {
  ShadesRepository({
    required AuthRepository authRepository,
    required MqttSmartHomeClient mqttSmartHomeClient,
    required ShadesApi shadesApi,
  })  : _authRepository = authRepository,
        _mqttSmartHomeClient = mqttSmartHomeClient,
        _shadesApi = shadesApi;

  final AuthRepository _authRepository;
  final MqttSmartHomeClient _mqttSmartHomeClient;
  final ShadesApi _shadesApi;

  final _shadesController = BehaviorSubject<List<Shade>>.seeded([]);

  StreamSubscription? _messageSubscription;
  Stream<List<Shade>> get shades => _shadesController.asBroadcastStream();

  void initShadeStatusSubscription(
    String homeId,
  ) {
    final topicFilter =
        RegExp(r'^home\/' + homeId + r'\/device\/shade\/([^\/]+)\/status$');
    _messageSubscription = _mqttSmartHomeClient.message
        .map((message) {
          final firstMatch = topicFilter.firstMatch(message.topic);
          final deviceId = firstMatch?.group(1) ?? '';
          final payload = ShadePayload.fromJson(jsonDecode(message.message));
          return ShadeStatus(deviceId: deviceId, payload: payload);
        })
        .where((status) => status.deviceId != '')
        .listen(_onShadeStatusChanged);
  }

  Future<void> fetchShadesInRoom({
    required String homeId,
    required String roomId,
  }) async {
    final authToken = await _authRepository.getAuthToken();
    if (authToken == null) {
      throw const ShadesApiException(message: 'unauthenticated');
    }
    try {
      final shades = await _shadesApi.fetchShadesInRoom(
        homeId: homeId,
        roomId: roomId,
        accessToken: authToken.accessToken,
      );
      _shadesController.add(shades);
    } catch (e) {
      _shadesController.addError(
          (e is ShadesApiException ? e.message : 'Something is wrong') ?? '');
    }
  }

  Future<void> updateShadeName({
    required String homeId,
    required String shadeId,
    required String name,
  }) async {
    final authToken = await _authRepository.getAuthToken();
    if (authToken == null) {
      throw const ShadesApiException(message: 'unauthenticated');
    }
    await _shadesApi.updateShadeName(
      homeId: homeId,
      shadeId: shadeId,
      name: name,
      accessToken: authToken.accessToken,
    );

    final shades = [..._shadesController.value];
    final shadeIndex = shades.indexWhere((shade) => shade.id == shadeId);
    if (shadeIndex == -1) return;
    shades[shadeIndex] = shades[shadeIndex].copyWith(name: name);
    _shadesController.add(shades);
  }

  void controlShade({
    required String homeId,
    required String deviceId,
    required ShadeAction action,
  }) {
    final topic = 'home/$homeId/device/shade/$deviceId/actionControl';
    final payload = ShadeControlDto(action: action, time: DateTime.now());
    _mqttSmartHomeClient.publish(topic, jsonEncode(payload.toJson()));
  }

  void _onShadeStatusChanged(ShadeStatus status) {
    final shades = [..._shadesController.value];
    final updatedLightIndex =
        shades.indexWhere((shade) => shade.id == status.deviceId);
    if (updatedLightIndex == -1) return;

    if (status.payload.time
        .isBefore(shades[updatedLightIndex].statusLastUpdatedAt)) {
      return;
    }

    shades[updatedLightIndex] = shades[updatedLightIndex].copyWith(
      properties: status.payload.properties,
      statusLastUpdatedAt: status.payload.time,
    );
    _shadesController.add(shades);
  }

  Future<void> dispose() {
    if (_messageSubscription != null) {
      _messageSubscription?.cancel();
    }
    return _shadesController.close();
  }
}
