// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeCapabilities _$ShadeCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShadeCapabilities',
      json,
      ($checkedConvert) {
        final val = ShadeCapabilities(
          hasLevel: $checkedConvert('hasLevel', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShadeCapabilitiesToJson(ShadeCapabilities instance) =>
    <String, dynamic>{
      'hasLevel': instance.hasLevel,
    };
