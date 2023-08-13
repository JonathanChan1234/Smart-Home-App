// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Processor _$ProcessorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Processor',
      json,
      ($checkedConvert) {
        final val = Processor(
          id: $checkedConvert('id', (v) => v as String),
          onlineStatus: $checkedConvert('onlineStatus', (v) => v as bool),
          mqttClientId: $checkedConvert('mqttClientId', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$ProcessorToJson(Processor instance) => <String, dynamic>{
      'id': instance.id,
      'mqttClientId': instance.mqttClientId,
      'onlineStatus': instance.onlineStatus,
    };
