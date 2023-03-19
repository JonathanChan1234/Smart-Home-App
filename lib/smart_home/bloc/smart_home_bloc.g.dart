// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_home_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartHomeState _$SmartHomeStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SmartHomeState',
      json,
      ($checkedConvert) {
        final val = SmartHomeState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$SmartHomeStatusEnumMap, v) ??
                  SmartHomeStatus.initial),
          smartHome: $checkedConvert(
              'smartHome',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map(
                          (e) => SmartHome.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          errorMessage:
              $checkedConvert('errorMessage', (v) => v as String? ?? ''),
        );
        return val;
      },
    );

Map<String, dynamic> _$SmartHomeStateToJson(SmartHomeState instance) =>
    <String, dynamic>{
      'status': _$SmartHomeStatusEnumMap[instance.status]!,
      'smartHome': instance.smartHome.map((e) => e.toJson()).toList(),
      'errorMessage': instance.errorMessage,
    };

const _$SmartHomeStatusEnumMap = {
  SmartHomeStatus.initial: 'initial',
  SmartHomeStatus.loading: 'loading',
  SmartHomeStatus.success: 'success',
  SmartHomeStatus.failure: 'failure',
};
