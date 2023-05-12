class MqttIncomingMessage {
  const MqttIncomingMessage({
    required this.topic,
    required this.message,
  });

  final String topic;
  final String message;
}
