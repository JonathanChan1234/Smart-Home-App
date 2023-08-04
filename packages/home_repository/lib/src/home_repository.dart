import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:home_api/home_api.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class HomeRepository {
  HomeRepository({
    required AuthRepository authRepository,
    required HomeApiClient homeApiClient,
    required MqttSmartHomeClient mqttSmartHomeClient,
  })  : _authRepository = authRepository,
        _homeApiClient = homeApiClient,
        _mqttSmartHomeClient = mqttSmartHomeClient;

  final AuthRepository _authRepository;
  final HomeApiClient _homeApiClient;
  final MqttSmartHomeClient _mqttSmartHomeClient;

  final _homeStreamController =
      BehaviorSubject<List<SmartHome>>.seeded(const []);

  Stream<List<SmartHome>> get homes =>
      _homeStreamController.asBroadcastStream();
  Stream<MqttClientConnectionStatus> get connectionStatus =>
      _mqttSmartHomeClient.status;

  StreamSubscription? _connectionSubscription;

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication,
          message: 'access token does not exist');
    }
    return token.accessToken;
  }

  Future<void> fetchHomeList() async {
    try {
      final homes = await _homeApiClient.getHomeList(
        accessToken: (await _getAccessToken()),
      );
      _homeStreamController.add(homes);
    } catch (e) {
      _homeStreamController.addError(e);
    }
  }

  Future<SmartHome> addHome({
    required String homeId,
    required String password,
  }) async {
    final home = await _homeApiClient.addHome(
      accessToken: (await _getAccessToken()),
      homeId: homeId,
      password: password,
    );
    final homes = [..._homeStreamController.value];
    homes.add(home);
    _homeStreamController.add(homes);
    return home;
  }

  Future<void> removeHome(String homeId) async {
    await _homeApiClient.removeHome(
      homeId: homeId,
      accessToken: (await _getAccessToken()),
    );
    final homes = [..._homeStreamController.value];
    final index = homes.indexWhere((home) => home.id == homeId);
    if (index == -1) return;
    homes.removeAt(index);
    _homeStreamController.add(homes);
  }

  Future<void> initMqttServerConnection(String homeId) async {
    await _mqttSmartHomeClient.connect(homeId);
    _connectionSubscription = _mqttSmartHomeClient.status.listen((status) {
      if (status != MqttClientConnectionStatus.connected) return;
      _mqttSmartHomeClient.subscribe('home/$homeId/#');
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
