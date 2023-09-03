import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/src/models/air_conditioner_payload.dart';
import 'package:air_conditioner_repository/src/models/air_conditioner_status.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:devices_api/devices_api.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/subjects.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class AirConditionerRepository {
  AirConditionerRepository({
    required AuthRepository authRepository,
    required AirConditionerApi airConditionerApi,
    required DeviceApi deviceApi,
    required MqttSmartHomeClient mqttClient,
  })  : _authRepository = authRepository,
        _airConditionerApi = airConditionerApi,
        _deviceApi = deviceApi,
        _mqttClient = mqttClient;

  final AuthRepository _authRepository;
  final AirConditionerApi _airConditionerApi;
  final DeviceApi _deviceApi;
  final MqttSmartHomeClient _mqttClient;

  final _streamController =
      BehaviorSubject<List<AirConditioner>>.seeded(const []);

  StreamSubscription? _messageSubscription;

  Stream<List<AirConditioner>> get devices =>
      _streamController.asBroadcastStream();

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication,
          message: 'access token does not exist');
    }
    return token.accessToken;
  }

  void initACStatusSubscription({
    required String homeId,
  }) {
    final topicFilter = RegExp(
        r'^home\/' + homeId + r'\/device\/airConditioner\/([^\/]+)\/status$');
    _messageSubscription = _mqttClient.message
        .map((message) {
          log('From ac repo: ${message.message}');
          final firstMatch = topicFilter.firstMatch(message.topic);
          final deviceId = firstMatch?.group(1) ?? '';
          final payload =
              AirConditionerPayload.fromJson(jsonDecode(message.message));
          return AirConditionerStatus(deviceId: deviceId, payload: payload);
        })
        .where((status) => status.deviceId != '')
        .listen(_onDeviceStatusChanged);
  }

  Future<void> fetchAcsInRoom({
    required String homeId,
    required String roomId,
  }) async {
    try {
      final lights = await _airConditionerApi.fetchAirConditioner(
          homeId: homeId,
          roomId: roomId,
          accessToken: (await _getAccessToken()));
      _streamController.add(lights);
    } catch (error) {
      _streamController.addError(error);
    }
  }

  void updateAcStatus({
    required String homeId,
    required String deviceId,
    required AirConditionerProperties properties,
  }) {
    final topic = 'home/$homeId/device/airConditioner/$deviceId/control';
    final payload = AirConditionerPayload(
      properties: properties,
      lastUpdatedAt: DateTime.now(),
    );
    _mqttClient.publish(topic, jsonEncode(payload.toJson()));
  }

  Future<void> updateAcInRoom({
    required String homeId,
    required String deviceId,
    required String name,
  }) async {
    await _deviceApi.updateDeviceName(
      homeId: homeId,
      deviceId: deviceId,
      name: name,
      accessToken: await _getAccessToken(),
    );

    final devices = [..._streamController.value];
    final updateDeviceIndex =
        devices.indexWhere((device) => device.id == deviceId);
    if (updateDeviceIndex == -1) return;

    devices[updateDeviceIndex] = devices[updateDeviceIndex].copyWith(
      name: name,
    );
    _streamController.add(devices);
  }

  void _onDeviceStatusChanged(AirConditionerStatus status) {
    final devices = [..._streamController.value];
    final deviceIndex =
        devices.indexWhere((device) => device.id == status.deviceId);
    if (deviceIndex == -1) return;

    if (status.payload.lastUpdatedAt
        .isBefore(devices[deviceIndex].statusLastUpdatedAt)) {
      return;
    }

    devices[deviceIndex] = devices[deviceIndex].copyWith(
      properties: status.payload.properties,
      onlineStatus: status.payload.onlineStatus,
      statusLastUpdatedAt: status.payload.lastUpdatedAt,
    );
    _streamController.add(devices);
  }

  /// cancel all the stream subscription and controller
  Future<void> dispose() async {
    if (_messageSubscription != null) {
      await _messageSubscription?.cancel();
    }
    await _streamController.close();
  }
}
