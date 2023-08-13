// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'processor_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessorStatusDto _$ProcessorStatusDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProcessorStatusDto',
      json,
      ($checkedConvert) {
        final val = ProcessorStatusDto(
          lastUpdatedAt: $checkedConvert('lastUpdatedAt', (v) => v as String),
          onlineStatus: $checkedConvert('onlineStatus', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$ProcessorStatusDtoToJson(ProcessorStatusDto instance) =>
    <String, dynamic>{
      'lastUpdatedAt': instance.lastUpdatedAt,
      'onlineStatus': instance.onlineStatus,
    };
