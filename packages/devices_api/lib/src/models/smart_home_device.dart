enum DeviceType { light, shade, unknown }

extension DeviceTypeX on DeviceType {
  String toTypeString() {
    switch (this) {
      case DeviceType.light:
        return 'light';
      case DeviceType.shade:
        return 'shade';
      case DeviceType.unknown:
        return 'unknown';
    }
  }
}

class SmartHomeDevice {
  const SmartHomeDevice({
    required this.deviceType,
    required this.numberOfDevice,
  });

  final DeviceType deviceType;
  final int numberOfDevice;
}
