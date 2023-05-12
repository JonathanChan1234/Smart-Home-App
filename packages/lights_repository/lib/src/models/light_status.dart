import 'package:lights_repository/src/models/light_payload.dart';

class LightStatus {
  const LightStatus({
    required this.deviceId,
    required this.payload,
  });

  final String deviceId;
  final LightPayload payload;
}
