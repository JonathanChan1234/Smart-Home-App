import 'package:auth_api/auth_api.dart';
import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/app/app.dart';
import 'package:smart_home/bootstrap.dart';
import 'package:smart_home/server_config.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final smartHomeApiClient = SmartHomeApiClient(plugin: sharedPreferences);
  final authRepository = AuthRepository(
    authApiClient: AuthApiClient(smartHomeApiClient: smartHomeApiClient),
    authLocalStorageApi: AuthLocalStorageApi(plugin: sharedPreferences),
  );
  final mqttSmartHomeClient = MqttSmartHomeClient(
    smartHomeApiClient: smartHomeApiClient,
    sharedPreferences: sharedPreferences,
    authRepository: authRepository,
    host: ServerConfig.mqttServerURL,
    port: ServerConfig.mqttServerPort,
  );
  final homeRepository = HomeRepository(
    authRepository: authRepository,
    homeApiClient: HomeApiClient(
      smartHomeApiClient: smartHomeApiClient,
    ),
    mqttSmartHomeClient: mqttSmartHomeClient,
  );
  final roomRepository = RoomRepository(
    authRepository: authRepository,
    roomApi: RoomApi(
      smartHomeApiClient: smartHomeApiClient,
    ),
  );
  final sceneRepository = SceneRepository(
    authRepository: authRepository,
    mqttSmartHomeClient: mqttSmartHomeClient,
    sceneApi: SceneApi(
      smartHomeApiClient: smartHomeApiClient,
    ),
  );
  final sceneActionRepository = SceneActionRepository(
    authRepository: authRepository,
    sceneActionApi: SceneActionApi(
      smartHomeApiClient: smartHomeApiClient,
    ),
  );
  final localeRepository = LocaleRepository(plugin: sharedPreferences);

  await authRepository.checkAuthState();
  await bootstrap(
    () => App(
      authRepository: authRepository,
      homeRepository: homeRepository,
      mqttSmartHomeClient: mqttSmartHomeClient,
      roomRepository: roomRepository,
      sharedPreferences: sharedPreferences,
      smartHomeApiClient: smartHomeApiClient,
      sceneRepository: sceneRepository,
      sceneActionRepository: sceneActionRepository,
      localeRepository: localeRepository,
    ),
  );
}
