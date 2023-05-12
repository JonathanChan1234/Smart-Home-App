import 'package:auth_api/auth_api.dart';
import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home/app/app.dart';
import 'package:smart_home/bootstrap.dart';
import 'package:smart_home/server_config.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final authRepository = AuthRepository(
    authApiClient: AuthApiClient(),
    authLocalStorageApi: AuthLocalStorageApi(plugin: sharedPreferences),
  );
  final smartHomeApiClient = SmartHomeApiClient();
  final mqttSmartHomeClient = MqttSmartHomeClient(
    smartHomeApiClient: smartHomeApiClient,
    sharedPreferences: sharedPreferences,
    authRepository: authRepository,
    host: ServerConfig.mqttServerURL,
    port: ServerConfig.mqttServerPort,
  );
  final homeRepository = HomeRepository(
    homeApiClient: HomeApiClient(
      authRepository: authRepository,
      smartHomeApiClient: smartHomeApiClient,
    ),
    mqttSmartHomeClient: mqttSmartHomeClient,
  );
  final roomRepository = RoomRepository(
    authRepository: authRepository,
    roomApi: RoomApi(smartHomeApiClient: smartHomeApiClient),
  );

  await authRepository.checkAuthState();
  await bootstrap(
    () => App(
      authRepository: authRepository,
      homeRepository: homeRepository,
      mqttSmartHomeClient: mqttSmartHomeClient,
      roomRepository: roomRepository,
      sharedPreferences: sharedPreferences,
      smartHomeApiClient: smartHomeApiClient,
    ),
  );
}
