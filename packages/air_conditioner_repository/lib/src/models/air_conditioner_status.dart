import 'package:air_conditioner_repository/src/models/air_conditioner_payload.dart';

class AirConditionerStatus {
  const AirConditionerStatus({
    required this.deviceId,
    required this.payload,
  });

  final String deviceId;
  final AirConditionerPayload payload;
}
