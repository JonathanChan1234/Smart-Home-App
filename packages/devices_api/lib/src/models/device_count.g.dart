// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceCount _$DeviceCountFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DeviceCount',
      json,
      ($checkedConvert) {
        final val = DeviceCount(
          mainCategory: $checkedConvert('mainCategory', (v) => v as int),
          count: $checkedConvert('count', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$DeviceCountToJson(DeviceCount instance) =>
    <String, dynamic>{
      'mainCategory': instance.mainCategory,
      'count': instance.count,
    };
