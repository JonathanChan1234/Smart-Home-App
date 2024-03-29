import 'package:auth_repository/auth_repository.dart';
import 'package:home_api/src/models/smart_home.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class HomeApiException implements Exception {
  const HomeApiException({required this.message});
  final String? message;
}

class HomeApiClient {
  HomeApiClient({
    required AuthRepository authRepository,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient;

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<SmartHome>> getHomeList() async {
    try {
      final response = await _smartHomeApiClient.httpGet(
          path: '/home',
          accessToken: (await _authRepository.getAuthToken())?.accessToken);
      final data = response.data;
      if (data == null) {
        throw const HomeApiException(message: 'Empty Data');
      }
      final smartHomeList = (data as List<dynamic>)
          .map((json) => SmartHome.fromJson(json as Map<String, dynamic>));
      return smartHomeList.toList();
    } on SmartHomeApiException catch (error) {
      throw HomeApiException(message: error.message);
    }
  }
}
