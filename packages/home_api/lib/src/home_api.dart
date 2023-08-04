import 'dart:convert';

import 'package:home_api/src/models/add_home_dto.dart';
import 'package:home_api/src/models/smart_home.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

class HomeApiClient {
  HomeApiClient({
    required SmartHomeApiClient smartHomeApiClient,
  }) : _smartHomeApiClient = smartHomeApiClient;

  final SmartHomeApiClient _smartHomeApiClient;

  Future<List<SmartHome>> getHomeList({required String accessToken}) async {
    final response = await _smartHomeApiClient.httpGet(
      path: '/home/user',
      accessToken: accessToken,
    );
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: 'Empty Data');
    }
    final smartHomeList = (data as List<dynamic>)
        .map((json) => SmartHome.fromJson(json as Map<String, dynamic>));
    return smartHomeList.toList();
  }

  Future<SmartHome> addHome({
    required String homeId,
    required String password,
    required String accessToken,
  }) async {
    final response = await _smartHomeApiClient.httpPost(
      path: '/home/$homeId/user',
      body: jsonEncode(AddHomeDto(password: password).toJson()),
      accessToken: accessToken,
    );
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
          code: ErrorCode.emptyBody, message: 'Empty Data');
    }
    return SmartHome.fromJson(data as Map<String, dynamic>);
  }

  Future<void> removeHome({
    required String homeId,
    required String accessToken,
  }) {
    return _smartHomeApiClient.httpDelete(
      path: '/home/$homeId/user',
      accessToken: accessToken,
    );
  }
}
