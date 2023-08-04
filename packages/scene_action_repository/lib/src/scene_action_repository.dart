import 'package:auth_repository/auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class SceneActionRepository {
  SceneActionRepository({
    required SceneActionApi sceneActionApi,
    required AuthRepository authRepository,
  })  : _sceneActionApi = sceneActionApi,
        _authRepository = authRepository;

  final SceneActionApi _sceneActionApi;
  final AuthRepository _authRepository;

  final _sceneActionStreamController =
      BehaviorSubject<List<SceneAction>>.seeded(const []);
  final _sceneDeviceStreamController =
      BehaviorSubject<List<Device>>.seeded(const []);

  Stream<List<SceneAction>> get actions =>
      _sceneActionStreamController.asBroadcastStream();
  Stream<List<Device>> get devices =>
      _sceneDeviceStreamController.asBroadcastStream();

  Future<String> _getAccessToken() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw const SmartHomeException(
          code: ErrorCode.badAuthentication, message: 'empty token');
    }
    return token.accessToken;
  }

  Future<void> fetchSceneAction({
    required String homeId,
    required String sceneId,
  }) async {
    try {
      final actions = await _sceneActionApi.fetchSceneActions(
        homeId: homeId,
        sceneId: sceneId,
        accessToken: (await _getAccessToken()),
      );
      _sceneActionStreamController.add(actions);
    } on SmartHomeException catch (e) {
      _sceneActionStreamController.addError(e);
    }
  }

  Future<void> fetchSceneDevice({
    required String homeId,
    required String sceneId,
  }) async {
    try {
      final devices = await _sceneActionApi.fetchSceneDevice(
        homeId: homeId,
        sceneId: sceneId,
        accessToken: (await _getAccessToken()),
      );
      _sceneDeviceStreamController.add(devices);
    } on SmartHomeException catch (e) {
      _sceneDeviceStreamController.addError(e);
    }
  }

  Future<void> createSceneAction<T extends DeviceAction>({
    required String homeId,
    required String sceneId,
    required DeviceMainCategory category,
    required DeviceActionDto<T> dto,
  }) async {
    final newAction = await _sceneActionApi.createSceneAction(
      homeId: homeId,
      sceneId: sceneId,
      accessToken: (await _getAccessToken()),
      category: category,
      dto: dto,
    );

    final actions = [..._sceneActionStreamController.value];
    actions.add(newAction);
    _sceneActionStreamController.add(actions);
  }

  Future<void> updateSceneAction<T extends DeviceAction>({
    required String homeId,
    required String sceneId,
    required String actionId,
    required DeviceMainCategory category,
    required DeviceActionDto<T> dto,
  }) async {
    await _sceneActionApi.updateSceneAction(
      homeId: homeId,
      sceneId: sceneId,
      accessToken: (await _getAccessToken()),
      actionId: actionId,
      category: category,
      dto: dto,
    );

    final actions = [..._sceneActionStreamController.value];
    final updateActionIndex =
        actions.indexWhere((action) => action.id == actionId);
    if (updateActionIndex == -1) {
      throw SmartHomeException(
        code: ErrorCode.resourceNotFound,
        message:
            'scene action (id: $actionId) does not exist in the collection',
      );
    }
    actions[updateActionIndex] = actions[updateActionIndex].copyWithAction(
      action: dto.deviceProperties.toJson(),
    );
    _sceneActionStreamController.add(actions);
  }

  Future<void> deleteSceneAction({
    required String homeId,
    required String sceneId,
    required String actionId,
  }) async {
    await _sceneActionApi.deleteSceneAction(
      homeId: homeId,
      sceneId: sceneId,
      accessToken: (await _getAccessToken()),
      actionId: actionId,
    );
    final actions = [..._sceneActionStreamController.value];
    final deleteActionIndex =
        actions.indexWhere((action) => action.id == actionId);
    if (deleteActionIndex == -1) {
      throw SmartHomeException(
        code: ErrorCode.resourceNotFound,
        message:
            'scene action (id: $actionId) does not exist in the collection',
      );
    }
    actions.removeAt(deleteActionIndex);
    _sceneActionStreamController.add(actions);
  }

  Future<void> dispose() async {
    await _sceneActionStreamController.close();
    _sceneDeviceStreamController.close();
  }
}
