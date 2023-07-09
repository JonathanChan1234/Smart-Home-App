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
  Future<List<DeviceCount>> fetchDevicesInRoom(
      String homeId, String roomId) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw DeviceApiException(message: 'unauthenticated');
    }
    try {
      final response = await _smartHomeApiClient.httpGet(
        path: '/home/$homeId/device/count?roomId=$roomId',
        accessToken: accessToken,
      );
      final body = response.data;
      if (body == null) throw DeviceApiException(message: 'Empty Body');
      return (body as List<dynamic>)
          .map((device) => DeviceCount.fromJson(device as Map<String, dynamic>))
          .toList();
    } on SmartHomeApiException catch (e) {
      throw DeviceApiException(message: e.message);
    }
  }
}
