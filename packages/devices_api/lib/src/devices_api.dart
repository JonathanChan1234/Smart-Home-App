import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:devices_api/src/models/models.dart';
import 'package:devices_api/src/models/update_device_dto.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class DeviceApi {
  DeviceApi({
    required AuthRepository authRepository,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient;

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;

  /// Fetch the number of devices in each category
  /// throw [SmartHomeExcpetion] for any error;
  Future<List<DeviceCount>> fetchDevicesInRoom(
      String homeId, String roomId) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw const SmartHomeException(
        code: ErrorCode.badAuthentication,
        message: 'empty auth token',
      );
    }
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/$homeId/device/count?roomId=$roomId',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    return (body as List<dynamic>)
        .map((device) => DeviceCount.fromJson(device as Map<String, dynamic>))
        .toList();
  }

  Future updateDeviceName({
    required String homeId,
    required String deviceId,
    required String name,
    required String accessToken,
  }) {
    return _smartHomeApiClient.httpPut(
      path: '/home/$homeId/device/$deviceId',
      body: jsonEncode(UpdateDeviceDto(name: name).toJson()),
      accessToken: accessToken,
    );
  }
}
