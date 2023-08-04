import 'package:auth_repository/auth_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class SceneRepository {
  SceneRepository({
    required AuthRepository authRepository,
    required MqttSmartHomeClient mqttSmartHomeClient,
    required SceneApi sceneApi,
  })  : _authRepository = authRepository,
        _mqttSmartHomeClient = mqttSmartHomeClient,
        _sceneApi = sceneApi;

  final AuthRepository _authRepository;
  final MqttSmartHomeClient _mqttSmartHomeClient;
  final SceneApi _sceneApi;
  final _sceneStreamController = BehaviorSubject<List<Scene>>.seeded(const []);

  Stream<List<Scene>> get scenes => _sceneStreamController.asBroadcastStream();

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication,
          message: 'access token does not exist');
    }
    return token.accessToken;
  }

  Future<void> fetchScenes({required String homeId}) async {
    try {
      final scenes = await _sceneApi.fetchHomeScenes(
        homeId: homeId,
        accessToken: (await _getAccessToken()),
      );
      _sceneStreamController.add(scenes);
    } catch (error) {
      _sceneStreamController.addError(error);
    }
  }

  Future<void> createScene({
    required String homeId,
    required String name,
  }) async {
    final newScene = await _sceneApi.createNewScene(
      homeId: homeId,
      name: name,
      accessToken: (await _getAccessToken()),
    );
    final scenes = [..._sceneStreamController.value];
    scenes.add(newScene);
    _sceneStreamController.add(scenes);
  }

  void activateScene({
    required String homeId,
    required String sceneId,
  }) {
    _mqttSmartHomeClient.publish('home/$homeId/scene/$sceneId', '');
  }

  Future<void> updateScene({
    required String homeId,
    required String sceneId,
    required String name,
  }) async {
    final scenes = [..._sceneStreamController.value];
    await _sceneApi.changeSceneName(
      homeId: homeId,
      sceneId: sceneId,
      name: name,
      accessToken: (await _getAccessToken()),
    );
    final updatedSceneIndex = scenes.indexWhere((scene) => scene.id == sceneId);
    if (updatedSceneIndex == -1) return;
    scenes[updatedSceneIndex] = scenes[updatedSceneIndex].copyWith(name: name);
    _sceneStreamController.add(scenes);
  }

  Future<void> deleteScene({
    required String homeId,
    required String sceneId,
  }) async {
    final scenes = [..._sceneStreamController.value];
    await _sceneApi.deleteScene(
      homeId: homeId,
      sceneId: sceneId,
      accessToken: (await _getAccessToken()),
    );
    final deleteSceneIndex = scenes.indexWhere((scene) => scene.id == sceneId);
    if (deleteSceneIndex == -1) return;
    scenes.removeAt(deleteSceneIndex);
    _sceneStreamController.add(scenes);
  }

  Future<void> dispose() {
    return _sceneStreamController.close();
  }
}
