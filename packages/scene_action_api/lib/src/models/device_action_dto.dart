import 'actions/device_action.dart';

class DeviceActionDto<T extends DeviceAction> {
  const DeviceActionDto({
    required this.deviceProperties,
    required this.deviceId,
  });

  final T deviceProperties;
  final String deviceId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'deviceProperties': deviceProperties.toJson(),
        'deviceId': deviceId,
      };
}
