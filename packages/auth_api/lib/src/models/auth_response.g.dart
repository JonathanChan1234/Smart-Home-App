// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AuthResponse',
      json,
      ($checkedConvert) {
        final val = AuthResponse(
          accessToken: $checkedConvert('accessToken', (v) => v as String),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
