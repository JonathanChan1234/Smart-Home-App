// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'error_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorBody _$ErrorBodyFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ErrorBody',
      json,
      ($checkedConvert) {
        final val = ErrorBody(
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$ErrorBodyToJson(ErrorBody instance) => <String, dynamic>{
      'message': instance.message,
    };
