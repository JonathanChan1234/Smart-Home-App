import 'package:auth_repository/auth_repository.dart';
import 'package:devices_api/src/models/models.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class DeviceApiException implements Exception {
  DeviceApiException({this.message});

  final String? message;
}

class DeviceApi {
  DeviceApi({
    required AuthRepository authRepository,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient;

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;

  /// Fetch the number of devices in each category
  /// throw [DeviceApiException] for any error;
  Future<List<SmartHomeDevice>> fetchDevicesInRoom(String roomId) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw DeviceApiException(message: 'unauthenticated');
    }
    try {
      final response = await _smartHomeApiClient.httpGet(
        path: '/room/$roomId/device',
        accessToken: accessToken,
      );
      final body = response.data;
      if (body == null) throw DeviceApiException(message: 'Empty Body');
      final devices = (body as List<dynamic>)
          .map((device) => Device.fromJson(device as Map<String, dynamic>))
          .toList();
      return devices
          .map(
            (device) => SmartHomeDevice(
              deviceType: DeviceType.values.firstWhere(
                  (value) => value.toTypeString() == device.deviceType,
                  orElse: () => DeviceType.unknown),
              numberOfDevice: device.numberOfDevices,
            ),
          )
          .toList();
    } on SmartHomeApiException catch (e) {
      throw DeviceApiException(message: e.message);
    }
  }

  Future<List<Shade>> fetchShadesInRoom(String roomId) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw DeviceApiException(message: 'unable to get access token');
    }
    final response = await _smartHomeApiClient.httpGet(
      path: '/room/$roomId/device/shade',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) throw DeviceApiException(message: 'Empty Body');
    final shades = (body as List<dynamic>)
        .map((shade) => Shade.fromJson(shade as Map<String, dynamic>))
        .toList();
    return shades;
  }
}
