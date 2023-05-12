import 'dart:async';

import 'package:home_api/home_api.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepository {
  HomeRepository({
    required HomeApiClient homeApiClient,
    required MqttSmartHomeClient mqttSmartHomeClient,
  })  : _homeApiClient = homeApiClient,
        _mqttSmartHomeClient = mqttSmartHomeClient;

  final HomeApiClient _homeApiClient;
  final MqttSmartHomeClient _mqttSmartHomeClient;

  final _homeStreamController =
      BehaviorSubject<List<SmartHome>>.seeded(const []);

  Stream<List<SmartHome>> get homes =>
      _homeStreamController.asBroadcastStream();
  Stream<MqttClientConnectionStatus> get connectionStatus =>
      _mqttSmartHomeClient.status;

  StreamSubscription? _connectionSubscription;

  Future<void> fetchHomeList() async {
    try {
      final homes = await _homeApiClient.getHomeList();
      _homeStreamController.add(homes);
    } catch (e) {
      _homeStreamController.addError(e);
    }
  }

  Future<void> initMqttServerConnection(String homeId) async {
    await _mqttSmartHomeClient.connect(homeId);
    _connectionSubscription = _mqttSmartHomeClient.status.listen((status) {
      if (status != MqttClientConnectionStatus.connected) return;
      _mqttSmartHomeClient.subscribe('home/$homeId/device/#');
    });
  }

  Future<void> closeStream() {
    return _homeStreamController.close();
  }

  Future<void> disconnectFromServer() async {
    if (_connectionSubscription != null) {
      await _connectionSubscription?.cancel();
    }
    _mqttSmartHomeClient.disconnect();
  }

  Future<void> dispose() async {
    await disconnectFromServer();
    await closeStream();
  }
}
