// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Device',
      json,
      ($checkedConvert) {
        final val = Device(
          deviceType: $checkedConvert('deviceType', (v) => v as String),
          numberOfDevices: $checkedConvert('numberOfDevices', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'deviceType': instance.deviceType,
      'numberOfDevices': instance.numberOfDevices,
    };
