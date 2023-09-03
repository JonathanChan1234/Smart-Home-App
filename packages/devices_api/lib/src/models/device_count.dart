import 'package:json_annotation/json_annotation.dart';

part 'device_count.g.dart';

@JsonSerializable()
class DeviceCount {
  const DeviceCount({
    required this.mainCategory,
    required this.count,
  });

  factory DeviceCount.fromJson(Map<String, dynamic> json) =>
      _$DeviceCountFromJson(json);

  final int mainCategory;
  final int count;

  Map<String, dynamic> toJson() => _$DeviceCountToJson(this);
}

enum DeviceMainCategory { light, shade, ac, unknown }

extension DeviceMainCategoryIntX on int {
  DeviceMainCategory toDeviceMainCategory() {
    switch (this) {
      case 0:
        return DeviceMainCategory.light;
      case 1:
        return DeviceMainCategory.shade;
      case 2:
        return DeviceMainCategory.ac;
      default:
        return DeviceMainCategory.unknown;
    }
  }

  String toDeviceURLpath() {
    switch (this) {
      case 0:
        return 'light';
      case 1:
        return 'shade';
      case 2:
        return 'ac';
      default:
        throw Exception('Unsupported device type');
    }
  }
}
