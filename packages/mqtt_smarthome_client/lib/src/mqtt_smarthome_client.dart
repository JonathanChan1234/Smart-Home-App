import 'dart:async';
import 'dart:developer';
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
    String host = defaultHost,
    int port = defaultPort,
  })  : _authRepository = authRepository,
        _sharedPreferences = sharedPreferences,
        _mqttClientApi = MqttClientApi(
          authRepository: authRepository,
          sharedPreferences: sharedPreferences,
          smartHomeApiClient: smartHomeApiClient,
        ),
        _mqttServerClient = MqttServerClient.withPort(host, '', port) {
    _mqttServerClient.server = getServerHost();
    _mqttServerClient.port = getServerPort();
  }

  static const defaultHost = '10.0.2.2';
  static const defaultPort = 1883;
  static const kMqttServerHostKey = '__mqtt_host_key__';
  static const kMqttServerPortKey = '__mqtt_port_key__';

  final MqttClientApi _mqttClientApi;
  final AuthRepository _authRepository;
  final MqttServerClient _mqttServerClient;
  final SharedPreferences _sharedPreferences;

  final _statusController = BehaviorSubject<MqttClientConnectionStatus>.seeded(
      MqttClientConnectionStatus.disconnected);
  final _messageController = PublishSubject<MqttIncomingMessage>();

  Stream<MqttClientConnectionStatus> get status =>
      _statusController.asBroadcastStream();

  Stream<MqttIncomingMessage> get message =>
      _messageController.asBroadcastStream();

  Future<void> setServerConfig(String host, int port) async {
    _mqttServerClient.server = host;
    _mqttServerClient.port = port;
    await _sharedPreferences.setString(kMqttServerHostKey, host);
    await _sharedPreferences.setInt(kMqttServerPortKey, port);
  }

  String getServerHost() {
    return _sharedPreferences.getString(kMqttServerHostKey) ?? defaultHost;
  }

  int getServerPort() {
    return _sharedPreferences.getInt(kMqttServerPortKey) ?? defaultPort;
  }

  Future<void> connect(String homeId) async {
    if (_mqttServerClient.connectionStatus!.state ==
        MqttConnectionState.connected) {
      _mqttServerClient.disconnect();
    }

    _mqttServerClient.keepAlivePeriod = 20;
    _mqttServerClient.autoReconnect = true;
    _mqttServerClient.connectionMessage =
        await _obtainConnectionMessage(homeId);
    _mqttServerClient.onConnected = _onConnected;
    _mqttServerClient.onDisconnected = _onDisconnected;
    _mqttServerClient.onAutoReconnect =
        () async => await _onAuthReconnect(homeId);

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
    if (_mqttServerClient.connectionStatus!.state !=
        MqttConnectionState.connected) {
      throw const MqttSmartHomeClientException(
          message:
              "Subscription cannot be done as client is currently disconnected from server");
    }
    _mqttServerClient.subscribe(topic, MqttQos.atLeastOnce);
    _mqttServerClient.updates!.listen(_onPayloadRecevied);
  }

  void publish(String topic, String payload) {
    if (_mqttServerClient.connectionStatus!.state !=
        MqttConnectionState.connected) {
      throw const MqttSmartHomeClientException(
          message:
              "Publish cannot be done as client is currently disconnected from server");
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _mqttServerClient.publishMessage(
      topic,
      MqttQos.exactlyOnce,
      builder.payload!,
      retain: true,
    );
  }

  void _onPayloadRecevied(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    log('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
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

  Future<void> _onAuthReconnect(String homeId) async {
    _mqttServerClient.connectionMessage =
        await _obtainConnectionMessage(homeId);
  }

  Future<MqttConnectMessage> _obtainConnectionMessage(String homeId) async {
    final client = await _mqttClientApi.getMqttClientId(homeId);
    final currentUser = await _authRepository.getCurrentUser();
    final token = await _authRepository.getAuthToken();
    if (currentUser == null || token == null) {
      throw const MqttSmartHomeClientException(message: "unauthenticated");
    }

    final connMess = MqttConnectMessage()
        .withClientIdentifier(client.clientId.toString())
        .startClean()
        .authenticateAs(currentUser.name, token.accessToken)
        .withWillQos(MqttQos.atLeastOnce);
    return connMess;
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
