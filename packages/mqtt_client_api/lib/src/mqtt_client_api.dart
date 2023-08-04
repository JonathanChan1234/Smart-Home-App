import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

import 'models/models.dart';

class MqttClientApi {
  MqttClientApi({
    required AuthRepository authRepository,
    required SharedPreferences sharedPreferences,
    required SmartHomeApiClient smartHomeApiClient,
  })  : _authRepository = authRepository,
        _smartHomeApiClient = smartHomeApiClient,
        _sharedPreferences = sharedPreferences;

  @visibleForTesting
  static const mqttClientIdCacheKey = '__mqtt_client_id__';

  final AuthRepository _authRepository;
  final SmartHomeApiClient _smartHomeApiClient;
  final SharedPreferences _sharedPreferences;

  String? _getValue(String key) => _sharedPreferences.getString(key);
  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  /// Get the mqtt client from the local cache\n
  ///
  /// Throw [MqttClientApiException] for unauthenticated user
  Future<MqttClientDto?> getMqttClientFromCache(String homeId) async {
    // Get the current user from auth repo
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw const SmartHomeException(
        code: ErrorCode.badAuthentication,
        message: "unauthenticated",
      );
    }

    final cacheString = _getValue(mqttClientIdCacheKey);
    if (cacheString == null) return Future.value(null);

    final clients = List<Map<dynamic, dynamic>>.from(
            jsonDecode(cacheString) as List)
        .map((json) => MqttClientDto.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    final clientIndex =
        clients.indexWhere((c) => c.homeId == homeId && c.userId == user.id);
    return clientIndex == -1 ? null : clients[clientIndex];
  }

  /// Save the mqtt client into the local storage for future use
  Future<void> cacheMqttClient(MqttClientDto client) {
    final cacheString = _getValue(mqttClientIdCacheKey);
    List<MqttClientDto> clients = [];
    if (cacheString != null) {
      clients =
          List<Map<dynamic, dynamic>>.from(jsonDecode(cacheString) as List)
              .map((json) =>
                  MqttClientDto.fromJson(Map<String, dynamic>.from(json)))
              .toList();
    }
    final clientIndex = clients.indexWhere(
        (c) => c.homeId == client.homeId && c.userId == client.userId);
    if (clientIndex == -1) {
      clients.add(client);
    } else {
      clients[clientIndex] = client;
    }
    return _setValue(mqttClientIdCacheKey, jsonEncode(clients));
  }

  /// Obtain a new mqtt client id from the web api
  Future<MqttClientDto> obtainMqttClientFromServer(String homeId) async {
    final accessToken = (await _authRepository.getAuthToken())?.accessToken;
    if (accessToken == null) {
      throw const SmartHomeException(
        code: ErrorCode.badAuthentication,
        message: 'Unable to get access token',
      );
    }
    final response = await _smartHomeApiClient.httpPost(
      path: '/home/$homeId/mqttClient',
      body: '',
      accessToken: accessToken,
    );
    final data = response.data;
    if (data == null) {
      throw const SmartHomeException(
        code: ErrorCode.emptyBody,
        message: 'Empty body',
      );
    }
    final mqttClient = MqttClientDto.fromJson(data as Map<String, dynamic>);
    return mqttClient;
  }

  /// Get the mqtt client from cache or server
  /// If no cache is found, obtain a new one from the server
  Future<MqttClientDto> getMqttClientId(String homeId) async {
    final cachedClient = await getMqttClientFromCache(homeId);
    if (cachedClient != null) return cachedClient;

    final newClient = await obtainMqttClientFromServer(homeId);
    await cacheMqttClient(newClient);
    return newClient;
  }
}
