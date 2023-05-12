import 'dart:async';
import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client_api/mqtt_client_api.dart';
import 'package:mqtt_smarthome_client/src/mqtt_incoming_message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

enum MqttClientConnectionStatus { connecting, connected, disconnected }

class MqttSmartHomeClient {
  MqttSmartHomeClient({
    required SmartHomeApiClient smartHomeApiClient,
    required SharedPreferences sharedPreferences,
    required AuthRepository authRepository,
    required String host,
    required int port,
  })  : _authRepository = authRepository,
        _mqttClientApi = MqttClientApi(
          authRepository: authRepository,
          sharedPreferences: sharedPreferences,
          smartHomeApiClient: smartHomeApiClient,
        ),
        _mqttServerClient = MqttServerClient.withPort(host, '', port);

  final MqttClientApi _mqttClientApi;
  final AuthRepository _authRepository;
  final MqttServerClient _mqttServerClient;

  final _statusController = BehaviorSubject<MqttClientConnectionStatus>.seeded(
      MqttClientConnectionStatus.disconnected);
  final _messageController = PublishSubject<MqttIncomingMessage>();

  Stream<MqttClientConnectionStatus> get status =>
      _statusController.asBroadcastStream();

  Stream<MqttIncomingMessage> get message =>
      _messageController.asBroadcastStream();

  Future<void> connect(String homeId) async {
    if (_mqttServerClient.connectionStatus!.state ==
        MqttConnectionState.connected) {
      _mqttServerClient.disconnect();
    }
    final client = await _mqttClientApi.getMqttClientId(homeId);
    _mqttServerClient.keepAlivePeriod = 20;

    final currentUser = await _authRepository.getCurrentUser();
    final token = await _authRepository.getAuthToken();
    if (currentUser == null || token == null) {
      throw const MqttSmartHomeClientException(message: "unauthenticated");
    }

    final connMess = MqttConnectMessage()
        .withClientIdentifier(client.clientId.toString())
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .authenticateAs(currentUser.name, token.accessToken)
        .withWillQos(MqttQos.atLeastOnce);
    _mqttServerClient.connectionMessage = connMess;
    _mqttServerClient.onConnected = _onConnected;
    _mqttServerClient.onDisconnected = _onDisconnected;

    _statusController.add(MqttClientConnectionStatus.connecting);
    try {
      _mqttServerClient.connect();
    } on NoConnectionException {
      _mqttServerClient.disconnect();
      throw const MqttSmartHomeClientException(
          message: "No Connection Exception");
    } on SocketException {
      _mqttServerClient.disconnect();
      throw const MqttSmartHomeClientException(message: "Socket Exception");
    }
  }

  void disconnect() {
    _mqttServerClient.disconnect();
  }

  void subscribe(String topic) {
    if (_mqttServerClient.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      throw const MqttSmartHomeClientException(
          message:
              "Subscription cannot be done as client is currently disconnected from server");
    }
    _mqttServerClient.subscribe(topic, MqttQos.atLeastOnce);
    _mqttServerClient.updates!.listen(_onPayloadRecevied);
  }

  void publish(String topic, String payload) {
    if (_mqttServerClient.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      throw const MqttSmartHomeClientException(
          message:
              "Publish cannot be done as client is currently disconnected from server");
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _mqttServerClient.publishMessage(
        topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void _onPayloadRecevied(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    // TODO: Remove print statement later
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
    if (_messageController.isClosed) return;
    _messageController.add(MqttIncomingMessage(topic: c[0].topic, message: pt));
  }

  void _onConnected() {
    if (_statusController.isClosed) return;
    _statusController.add(MqttClientConnectionStatus.connected);
  }

  void _onDisconnected() {
    if (_statusController.isClosed) return;
    _statusController.add(MqttClientConnectionStatus.disconnected);
  }

  void dispose() {
    _statusController.close();
    _messageController.close();
    if (_mqttServerClient.connectionStatus!.state ==
        MqttConnectionState.connected) {
      _mqttServerClient.disconnect();
    }
  }
}

class MqttSmartHomeClientException implements Exception {
  const MqttSmartHomeClientException({this.message});
  final String? message;
}
