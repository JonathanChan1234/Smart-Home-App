import 'package:air_conditioner_api/src/models/air_conditioner.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class AirConditionerApi {
  AirConditionerApi({required SmartHomeApiClient apiClient})
      : _apiClient = apiClient;

  final SmartHomeApiClient _apiClient;

  Future<List<AirConditioner>> fetchAirConditioner({
    required String homeId,
    required String roomId,
    required String accessToken,
  }) async {
    final response = await _apiClient.httpGet(
      path: '/home/$homeId/ac?roomId=$roomId',
      accessToken: accessToken,
    );
    final body = response.data;
    if (body == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty Body',
      );
    }
    final ac = (body as List<dynamic>)
        .map((ac) => AirConditioner.fromJson(ac as Map<String, dynamic>))
        .toList();
    return ac;
  }
}
