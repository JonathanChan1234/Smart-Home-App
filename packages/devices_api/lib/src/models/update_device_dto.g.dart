// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDeviceDto _$UpdateDeviceDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateDeviceDto',
      json,
      ($checkedConvert) {
        final val = UpdateDeviceDto(
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateDeviceDtoToJson(UpdateDeviceDto instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
