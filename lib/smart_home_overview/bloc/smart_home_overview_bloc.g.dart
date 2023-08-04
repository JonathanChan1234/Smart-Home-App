// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_home_overview_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartHomeOverviewState _$SmartHomeOverviewStateFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SmartHomeOverviewState',
      json,
      ($checkedConvert) {
        final val = SmartHomeOverviewState(
          tab: $checkedConvert(
              'tab',
              (v) =>
                  $enumDecodeNullable(_$SmartHomeTabEnumMap, v) ??
                  SmartHomeTab.home),
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$SmartHomeOverviewStatusEnumMap, v) ??
                  SmartHomeOverviewStatus.initial),
          homes: $checkedConvert(
              'homes',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map(
                          (e) => SmartHome.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          requestError:
              $checkedConvert('requestError', (v) => v as String? ?? ''),
          eventType: $checkedConvert(
              'eventType',
              (v) =>
                  $enumDecodeNullable(_$SmartHomeOverviewEventTypeEnumMap, v) ??
                  SmartHomeOverviewEventType.fetch),
        );
        return val;
      },
    );

Map<String, dynamic> _$SmartHomeOverviewStateToJson(
        SmartHomeOverviewState instance) =>
    <String, dynamic>{
      'tab': _$SmartHomeTabEnumMap[instance.tab]!,
      'status': _$SmartHomeOverviewStatusEnumMap[instance.status]!,
      'eventType': _$SmartHomeOverviewEventTypeEnumMap[instance.eventType]!,
      'homes': instance.homes.map((e) => e.toJson()).toList(),
      'requestError': instance.requestError,
    };

const _$SmartHomeTabEnumMap = {
  SmartHomeTab.home: 'home',
  SmartHomeTab.settings: 'settings',
};

const _$SmartHomeOverviewStatusEnumMap = {
  SmartHomeOverviewStatus.initial: 'initial',
  SmartHomeOverviewStatus.loading: 'loading',
  SmartHomeOverviewStatus.success: 'success',
  SmartHomeOverviewStatus.failure: 'failure',
};

const _$SmartHomeOverviewEventTypeEnumMap = {
  SmartHomeOverviewEventType.fetch: 'fetch',
  SmartHomeOverviewEventType.add: 'add',
  SmartHomeOverviewEventType.delete: 'delete',
};
