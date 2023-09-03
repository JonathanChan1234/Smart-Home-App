import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device extends Equatable {
  const Device({
    required this.id,
    required this.name,
    required this.roomId,
    required this.homeId,
    required this.mainCategory,
    required this.subCategory,
    required this.properties,
    required this.capabilities,
    required this.onlineStatus,
    required this.statusLastUpdatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  DeviceMainCategory get deviceMainCategory =>
      mainCategory.toDeviceMainCategory();
  DeviceSubCategory get deviceSubCategory => mainCategory.toDeviceSubCategory();

  final String id;
  final String name;
  final String roomId;
  final String homeId;
  final int mainCategory;
  final int subCategory;
  final Map<String, dynamic> properties;
  final Map<String, dynamic> capabilities;
  final bool onlineStatus;
  final DateTime statusLastUpdatedAt;

  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        roomId,
        homeId,
        mainCategory,
        subCategory,
        properties,
        capabilities,
        onlineStatus,
        statusLastUpdatedAt,
      ];
}

enum DeviceMainCategory {
  light,
  shade,
  ac,
  unknown,
}

enum DeviceSubCategory {
  dimmer,
  lightSwitch,
  rollerShade,
  motorShade,
  airConditioner,
  unknown,
}

extension DeviceMainCategoryExtension on int {
  DeviceMainCategory toDeviceMainCategory() {
    return this >= DeviceMainCategory.values.length
        ? DeviceMainCategory.unknown
        : DeviceMainCategory.values[this];
  }

  DeviceSubCategory toDeviceSubCategory() {
    return this >= DeviceSubCategory.values.length
        ? DeviceSubCategory.unknown
        : DeviceSubCategory.values[this];
  }
}

extension DeviceMainCategoryIcon on DeviceMainCategory {
  IconData get icon {
    switch (this) {
      case DeviceMainCategory.light:
        return Icons.light_outlined;
      case DeviceMainCategory.shade:
        return Icons.roller_shades;
      case DeviceMainCategory.unknown:
        return Icons.question_mark;
      case DeviceMainCategory.ac:
        return Icons.hvac_sharp;
    }
  }
}
